import logging
import json
import os
import libreria_ai_per_tutti as ai
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI

class Does_Assistant_Exist:
    def __init__(self, logger:logging.Logger):
        self.logger = logger
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
    
    def process_assistant(self, assistant_name:str) -> bool:
        """
        Entrypoint. Returns true if the assistant exists, otherwise false.
        """
        try:
            my_assitant = self.client.beta.assistants.retrieve(assistant_name)
            self.logger.info(f"MY_ASSISTANT: {my_assitant}")
            return True
        except Exception as e:
            self.logger.error(f"ASSISTANT DOES NOT EXIST: {e}")
            return False