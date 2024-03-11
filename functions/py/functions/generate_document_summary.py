import logging
import json
import os
from .. import commons
import libreria_ai_per_tutti as ai
from py.commons import *

class Generated_Document:
    def __init__(self, logger:logging.Logger, payload:str, object_id:str):
        self.logger = logger
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e
        self.filename = os.path.basename(self.object_id)
        self.pathname = os.path.dirname(self.object_id)
        self.praticapath = os.path.dirname(self.pathname)
    
    def get_summary(self, text):
        """
        Uses the GPT engine to create a summary of the legal document.
        """
        self.logger.info("Building messages array...")
        messages=[
            {
                "role": "system",
                "content": DOCUMENT_SUMMARY_GPT_MESSAGE
            },
            {
                "role": "user",
                "content": text
            }
        ]
        self.logger.info("Summarizing the file...")
        try:
            summary = ai.gpt_call(messages=messages, engine=SUMMARY_ENGINE, temperature=0)
        except Exception as e:
            self.logger.error(f"Error while summarizing the file: {e}")
            raise f"Error while summarizing the file: {e}"

        return summary
    
    def get_blob_output_name(self):
        """Get the name of the output blob."""
        if "originale_" in self.filename:
            return self.filename.replace("originale_", "")
        else:
            return self.filename
        
    def process_document(self) -> str:
        """Process the document."""
        
        self.logger.info(f"File {self.object_id} is a txt file. Processing...")
        text = commons.Cloud_Storege_Util(self.logger).read_text_file(self.object_id)
        self.logger.info(f"Text from file: {text}")
        summary = self.get_summary(text)
        blob_filename = self.get_blob_output_name()
        self.logger.info(f"Writing summary to {blob_filename}...")
        commons.Cloud_Storege_Util(self.logger).write_text_file(f"{self.praticapath}/riassunti/{blob_filename}", summary)   
        return
