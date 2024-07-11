import json
from py.logger_config import LoggerConfig
import os
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI
import logging

class Create_Thread:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.logger = LoggerConfig().setup_logging()
    
    def create_thread(self) -> str:
        try:
            response = self.client.beta.threads.create()
            return response.id
        except Exception as e:
            self.logger.info(f"THREAD CREATION FAILED: {e}")
            raise e