import json
import os
import libreria_ai_per_tutti as ai
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI
import logging
from py.logger_config import logger

class Create_Thread:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
    
    def create_thread(self) -> str:
        try:
            response = self.client.beta.threads.create()
            return response.id
        except Exception as e:
            logger.info(f"THREAD CREATION FAILED: {e}")
            raise e