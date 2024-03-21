from py.logger_config import logger
from openai import OpenAI, OpenAIError
import os
from py.constants import *
from py.commons import Cloud_Storege_Util

class Create_Assistant:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.engine = CREATE_ASSISTANT_ENGINE
    
    def upload_document(self, blob_name:str) -> str:
        try:
            filebytes = Cloud_Storege_Util(logger).get_file_bytes(blob_name)
        except Exception as e:
            logger.error(f"Error while reading file: {e}")
            raise f"Error while reading file: {e}"
        try:
            response = self.client.files.create(file=filebytes, purpose="assistants")
            logger.info("Document uploaded successfully")
            return response.id
        except Exception as e:
            logger.error(f"Error while uploading document: {e}")
            raise f"Error while uploading document: {e}"
    
    def process_assistant(self, assistant_name:str) -> bool:
        """
        Entrypoint. Creates the assistant with the given name.
        """
        document_id = self.upload_document("accounts/lawli/pratiche/1/documenti/originale_Gmail - New Order Confirmation_ IN139829.pdf")
        try:
            my_assistant = self.client.beta.assistants.create(model=self.engine, name=assistant_name, file_ids=[document_id], tools=[{"type": "retrieval"}])
            logger.info(f"MY_ASSISTANT: {my_assistant}")
            return my_assistant.id
        except OpenAIError as e:
            logger.error(f"OpenAI Error while creating assistant: {e}")
            raise f"OpenAI Error while creating assistant: {e}"
        except Exception as e:
            logger.error(f"Error while creating assistant: {e}")
            raise f"Error while creating assistant: {e}"