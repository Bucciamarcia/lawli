import logging
from py.logger_config import logger
from openai import OpenAI
import os
from py.constants import *
from py.commons import Cloud_Storege_Util

class Create_Assistant:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.engine = CREATE_ASSISTANT_ENGINE
    
    def upload_document(self, blob_name:str):
        filebytes = Cloud_Storege_Util(logger).get_file_bytes("accounts/lawli/pratiche/1/documenti/originale_Gmail - New Order Confirmation_ IN139829.pdf")
        try:
            self.client.files.create(filebytes, purpose="assistants")
            logger.info("Document uploaded successfully")
        except Exception as e:
            logger.error(f"Error while uploading document: {e}")
            raise f"Error while uploading document: {e}"
    
    def process_assistant(self, assistant_name:str) -> bool:
        """
        Entrypoint. Creates the assistant with the given name.
        """
        
        try:
            my_assistant = self.client.beta.assistants.create(model=self.engine, name=assistant_name)
            logger.info(f"MY_ASSISTANT: {my_assistant}")
            return True
        except Exception as e:
            logger.error(f"Error while creating assistant: {e}")
            return False