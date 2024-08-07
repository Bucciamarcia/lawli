from openai import OpenAI, OpenAIError
from py.constants import OPENAI_API_KEY, EXTRACT_DATE_ENGINE, EXTRACT_DATE_PROMPT
from py.commons import change_ext_to_txt, Cloud_Storege_Util, Firestore_Util
from py.logger_config import LoggerConfig
from datetime import datetime


class ExtractDate:
    def __init__(self, account_name: str, pratica_id: str, document_name: str, extension: str):
        self.account_name = account_name
        self.pratica_id = pratica_id
        self.document_name = document_name
        self.client = OpenAI(api_key=OPENAI_API_KEY)
        self.logger = LoggerConfig().setup_logging()
        self.extension = extension

    def write_date_to_db(self, date: datetime, path: str) -> None:
        """Writes the date to Firestore."""
        db = Firestore_Util()
        db.write_to_firestore(data={"data": date}, path=path, merge=True)

    def does_date_exist(self) -> bool:
        """Checks if the date exists in Firestore."""
        path = f"accounts/{self.account_name}/pratiche/{self.pratica_id}/documenti/{self.document_name}.{self.extension}"
        self.logger.debug(f"Checking if date exists in: {path}")
        db = Firestore_Util()
        doc = db.get_document(path)
        if doc:
            self.logger.debug(f"Doc found: {doc}")
            try:
                if doc["data"]:
                    self.logger.debug(f"Date found: {doc['data']}")
                    return True
            except KeyError:
                self.logger.debug("Date not found.")
                return False
            else:
                self.logger.debug("Date not found.")
                return False
        else:
            self.logger.error("Document not found.")
            return False

    def extract_date(self, path: str | None = None) -> str:
        if self.does_date_exist():
            self.logger.info("Data già presente in Firestore. Non faccio nulla.")
            return "Data già presente in Firestore."
        document_txt = change_ext_to_txt(self.document_name)
        storage = Cloud_Storege_Util()
        self.logger.info(f"Extracting the date from {document_txt}")
        try:
            text = storage.read_text_file(
                account_name=self.account_name,
                pratica_id=self.pratica_id,
                document_id=document_txt,
            )
        except Exception as e:
            self.logger.error(f"Errore durante la lettura del file: {e}")
            raise e
        messages = [
            {"role": "system", "content": EXTRACT_DATE_PROMPT},
            {"role": "user", "content": text},
        ]
        tries = 0
        max_retries = 3

        while tries < max_retries:
            self.logger.info(f"Tentativo {tries + 1} di estrazione della data.")
            try:
                completion = self.client.chat.completions.create(messages=messages, model=EXTRACT_DATE_ENGINE)  # type: ignore
                data = completion.choices[0].message.content
                self.logger.info(f"Data estratta: {data}")

                if data is None or "trovata" in data:
                    self.logger.info("Data non trovata.")
                    return "Data non trovata"
                else:
                    self.logger.info(f"Data trovata: {data}")
                    if path:
                        datetime_obj = datetime.strptime(data, "%Y-%m-%d")
                        self.write_date_to_db(datetime_obj, path)
                    return data
            except OpenAIError as e:
                self.logger.error(f"Errore OpeanAI durante l'estrazione della data: {e}")
                tries += 1
                if tries >= max_retries:
                    self.logger.warning("Data non trovata con 3 tentativi.")
                    return "Data non trovata"

        self.logger.warning("Data non trovata: errore generico.")
        return "Data non trovata"  # Add this line to ensure a value of type 'str' is always returned
