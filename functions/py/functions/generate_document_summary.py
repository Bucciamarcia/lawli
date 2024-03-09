import logging
import json
import os
from .. import commons, constants
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
        
    def check_ext(self):
        """Check if the file is a txt file."""
        if self.filename.endswith(".txt"):
            return True
        else:
            return False
    
    def get_summary(self, text):
        """
        Uses the GPT engine to create a summary of the legal document.
        """
        logger = logging.getLogger(__name__)
        logger.info("Building messages array...")
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
        logger.info("Summarizing the file...")
        try:
            summary = ai.gpt_call(messages=messages, engine=SUMMARY_ENGINE, temperature=0)
        except Exception as e:
            self.logger.error(f"Error while summarizing the file: {e}")
            raise f"Error while summarizing the file: {e}"

        return summary
        
    def process_document(self) -> str:
        """Process the document."""
        
        if self.check_ext():
            self.logger.info(f"File {self.object_id} is a txt file. Processing...")
            text = commons.Cloud_Storege_Util(self.logger).read_text_file(self.object_id)
            self.logger.info(f"Text from file: {text}")
            summary = self.get_summary(text)
            return
        else:
            self.logger.info(f"File {self.object_id} is not a txt file - exiting.")
            return