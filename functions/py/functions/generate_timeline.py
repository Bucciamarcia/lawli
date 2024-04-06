import json
from concurrent.futures import ThreadPoolExecutor, as_completed
from py.logger_config import LoggerConfig
import os
from openai import OpenAI, OpenAIError
from py.commons import *
from py.constants import *

class TimelineGenerator:
    """
    Class that generates a timeline for a client.
    """
    def __init__(self, account_name:str, pratica_id: str):
        self.account_name = account_name
        self.logger = LoggerConfig().setup_logging()
        self.pratica_id = pratica_id
        self.client = OpenAI(api_key=OPENAI_API_KEY)

    def get_document_content(self, doc_id: str) -> str:
        """
        Get the content of a document from Firestore.
        """
        doc_id_no_ext = os.path.splitext(doc_id)[0]
        try:
            self.logger.info("Getting document content")
            path = f"accounts/{self.account_name}/pratiche/{self.pratica_id}/documenti/{doc_id_no_ext}.txt"
            self.logger.info(f"Path: {path}")
            return Cloud_Storege_Util().read_text_file(path)
        except Exception as e:
            raise Exception(e)

    def get_documents(self) -> list[str]:
        """
        Get all the files for the client. Returns a list of all the documents.
        """
        self.logger.info("Getting all documents")
        doc_ids = Firestore_Util().get_all_document_ids(assistito=self.account_name, pratica=self.pratica_id)
        documents = []
        for doc_id in doc_ids:
            self.logger.info(f"Getting document: {doc_id}")
            documents.append(self.get_document_content(doc_id))
        return documents
    
    def get_document_timeline(self, doc) -> dict[str, str]:
        """
        Generate a timeline for a single document.
        """
        try:
            response = self.client.chat.completions.create(
                model=GENERATE_TIMELINE_ENGINE,
                response_format= {"type": "json_object"},
                messages= [
                    {"role": "system", "content": GENERATE_TIMELINE_FIRST_PROMPT},
                    {"role": "user", "content": doc}
                ],
                temperature=0
            )
        except OpenAIError as e:
            self.logger.error(f"Error while generating timeline for document: {doc}")
            raise Exception(e)

        return(json.loads(response.choices[0].message.content))

    def summarize_timeline(self, timeline: dict[str, str]) -> dict[str, str]:
        """
        Takes a timeline generated by the documents and removes the duplicate information.
        """
        try:
            response = self.client.chat.completions.create(
                model=CLEAR_TIMELINE_ENGINE,
                response_format= {"type": "json_object"},
                messages = [
                    {"role": "system", "content": GENERATE_TIMELINE_CLEAR_TIMELINE_SYSPROMPT},
                    {"role": "user", "content": json.dumps(timeline)}
                ],
                temperature=0
            )
            self.logger.debug(f"Summarized timeline: {response.choices[0].message.content}")
        except OpenAIError as e:
            self.logger.error(f"Error while summarizing timeline: {timeline}")
            raise Exception(e)

        return json.loads(response.choices[0].message.content) 

    def generate_timeline(self) -> str:
        """
        Entrypoint for the function. Generates a timeline for the client and returns it as a string, processing documents in parallel.
        """
        documents = self.get_documents()
        timeline = {"timeline": []}
        
        # Use ThreadPoolExecutor to process documents in parallel
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = [executor.submit(self.get_document_timeline, doc) for doc in documents]
            for future in as_completed(futures):
                try:
                    new_timeline = future.result()
                    timeline["timeline"].extend(new_timeline["timeline"])
                except Exception as exc:
                    self.logger.error(f"Generated an exception: {exc}")

        self.logger.info(f"SUCCESS! Generated timeline: {timeline}")
        summary = self.summarize_timeline(timeline)
        return json.dumps(summary)