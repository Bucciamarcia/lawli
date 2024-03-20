import json
import os
import libreria_ai_per_tutti as ai
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI
import logging
from py.logger_config import logger

class Interrogate_Chatbot:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
    
    def add_message_to_thread(self, message:str, thread_id:str) -> None:
        try:
            self.client.beta.threads.messages.create(thread_id=thread_id, content=message, role="user")
        except Exception as e:
            logger.info(f"MESSAGE ADDITION FAILED: {e}")
            raise e
    
    def process_interrogation(self, assistant_name:str, message:str, thread_id:str) -> None:
        pass