import json
import os
import libreria_ai_per_tutti as ai
from py.logger_config import LoggerConfig
from py.commons import *
from py.constants import *


class Brief_Description:
    def __init__(self, payload:str, object_id:str):
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

    def generate_brief_description(self, text:str, filename:str) -> str:
        """
        Uses the GPT engine to create a brief description of the legal document.
        """
        self.logger.info("Generating GPT message...")

        messages = [
            {
                "role": "system",
                "content": BRIEF_DESCRIPTION_GPT_MESSAGE
            },
            {
                "role": "user",
                "content": USR_MSG_TEMPLATE.format(filename=filename, text=text)
            }
        ]

        try:
            return(ai.gpt_call(messages=messages, engine=SUMMARY_ENGINE, temperature=0, apikey=os.environ.get("OPENAI_APIKEY")))
        except Exception as e:
            self.logger.error(f"Error while generating the brief description: {e}")
            raise f"Error while generating the brief description: {e}"
        
    def get_blob_output_name(self, original_filename) -> str:
        """Get the name of the output blob."""

        if "originale_" in self.filename:
            return original_filename.replace("originale_", "")
        else:
            return original_filename
        
    def get_original_filename(self):
        """Get the original extension of the file."""
        filname_no_ext = os.path.splitext(self.filename)[0]
        original_filename = Firestore_Util().search_document(path = "accounts/lawli/pratiche/1/documenti", filename=filname_no_ext)
        return original_filename

    def process_brief_description(self) -> str:
        """Entrypoint of the function. Process the brief description."""
        self.logger.info(f"File {self.object_id} is a txt file. Processing...")
        text = Cloud_Storege_Util(self.logger).read_text_file(self.object_id)

        data = {
            "brief_description": self.generate_brief_description(text, self.filename)
        }

        original_filename = self.get_original_filename()

        document_path = f"{self.praticapath}/documenti/{self.get_blob_output_name(original_filename)}"
        Firestore_Util().write_to_firestore(data=data, merge=True, path=document_path)
