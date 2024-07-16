import json
import os
import re
from openai import OpenAI, OpenAIError
from py.logger_config import LoggerConfig
from py.commons import Firestore_Util, Cloud_Storege_Util
from py.constants import (
    BRIEF_DESCRIPTION_ENGINE,
    BRIEF_DESCRIPTION_GPT_MESSAGE,
    USR_MSG_TEMPLATE,
)


class Brief_Description:
    def __init__(self, payload: str, object_id: str):
        self.logger = LoggerConfig().setup_logging()
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e
        self.filename = os.path.basename(self.object_id)
        self.pathname = os.path.dirname(self.object_id)
        self.praticapath = os.path.dirname(self.pathname)
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))

    def generate_brief_description(self, text: str, filename: str) -> str:
        """
        Uses the GPT engine to create a brief description of the legal document.
        """
        self.logger.info("Generating GPT message...")

        messages = [
            {"role": "system", "content": BRIEF_DESCRIPTION_GPT_MESSAGE},
            {
                "role": "user",
                "content": USR_MSG_TEMPLATE.format(filename=filename, text=text),
            },
        ]

        try:
            response = self.client.chat.completions.create(
                model=BRIEF_DESCRIPTION_ENGINE,
                messages=messages,
                temperature=0,
            )
            return response.choices[0].message.content
        except OpenAIError as e:
            self.logger.error(f"Error while generating the brief description: {e}")
            raise Exception(f"Error while generating the brief description: {e}")

    def get_blob_output_name(self, original_filename) -> str:
        """Get the name of the output blob."""
        self.logger.debug(f"Original filename: {original_filename}")

        if "originale_" in self.filename:
            return original_filename.replace("originale_", "")
        else:
            return original_filename

    def get_original_filename(self, pratica_number: str, account_id: str) -> str:
        """Get the original extension of the file."""
        filname_no_ext = os.path.splitext(self.filename)[0]
        original_filename = Firestore_Util().search_document(
            path=f"accounts/{account_id}/pratiche/{pratica_number}/documenti",
            filename=filname_no_ext,
        )
        return original_filename if original_filename else self.filename

    def process_brief_description(self) -> None:
        """Entrypoint of the function. Process the brief description."""
        self.logger.info(f"File {self.object_id} is a txt file. Processing...")
        pattern = r"pratiche/(\d+)/documenti"
        match = re.search(pattern, self.object_id)
        account_pattern = r"raccounts/([^/]+)/pratiche"
        match_pattern = re.search(account_pattern, self.object_id)

        if match:
            pratica_number: str = match.group(1)
        else:
            self.logger.error(
                f"Error while extracting pratica number from {self.object_id}"
            )
            return
        if match_pattern:
            account_id: str = match_pattern.group(1)
        else:
            self.logger.error(
                f"Error while extracting account id from {self.object_id}"
            )
            return

        text = Cloud_Storege_Util().read_text_file(self.object_id)

        data = {
            "brief_description": self.generate_brief_description(text, self.filename)
        }

        original_filename = self.get_original_filename(pratica_number, account_id)

        document_path = f"{self.praticapath}/documenti/{self.get_blob_output_name(original_filename)}"
        Firestore_Util().write_to_firestore(data=data, merge=True, path=document_path)
