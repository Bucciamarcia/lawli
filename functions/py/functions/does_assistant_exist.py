import json
import os
import libreria_ai_per_tutti as ai
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI
import logging
from py.logger_config import logger


class Does_Assistant_Exist:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
    
    def process_assistant(self, assistant_name:str) -> bool:
        """
        Entrypoint. Returns true if the assistant exists, otherwise false.
        """
        try:
            my_assitant = self.client.beta.assistants.retrieve(assistant_name)
            logger.info(f"MY_ASSISTANT: {my_assitant}")
            return True
        except Exception as e:
            logger.info(f"ASSISTANT DOES NOT EXIST: {e}")
            return False