import json
import os
import libreria_ai_per_tutti as ai
from py.commons import *
from py.constants import *
from firebase_admin.firestore import firestore
from openai import OpenAI, OpenAIError
import re
import logging
import time
from py.logger_config import logger

class Interrogate_Chatbot:
    def __init__(self):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
    
    def add_message_to_thread(self, message:str, thread_id:str) -> None:
        logger.info("Running add_message_to_thread")
        try:
            self.client.beta.threads.messages.create(thread_id=thread_id, content=message, role="user")
        except Exception as e:
            logger.error(f"MESSAGE ADDITION FAILED: {e}")
            raise e
    
    def run_assistant(self, assistant_id:str, thread_id:str) -> str:
        logger.info("Running run_assistant")
        try:
            run = self.client.beta.threads.runs.create(
                thread_id=thread_id,
                assistant_id=assistant_id
            )
            return run.id
        except OpenAIError as e:
            logger.error(f"OPENAIERROR: {e}")
            raise e
        except Exception as e:
            logger.error(f"ASSISTANT RUN FAILED: {e}")
            raise e
    
    def wait_loop(self, thread_id:str, run_id:str, timeout:int) -> None:
        start_time = time.time()
        while True:
            if time.time() - start_time > timeout:
                raise Exception("Timeout")
            try:
                run = self.client.beta.threads.runs.retrieve(thread_id=thread_id, run_id=run_id)
            except:
                raise Exception("Error retrieving run")
            if run.status == "completed":
                break
            time.sleep(1)

    def get_latest_assistant_message(self, thread_messages) -> list:
        logging.info("Running get_latest_assistant_message")
        assistant_messages = []

        for message in thread_messages:
            if message.role == "assistant":
                assistant_messages.append(message)
            else:
                break

        return assistant_messages

    def get_messages_texts(self, latest_assistant_messages:list) -> list:
        messages_text = []
        for message in latest_assistant_messages:
            message_text = message.content[0].text.value
            messages_text.append(message_text)
        
        return messages_text[::-1] # La lista originale usa ordine cronologico inverso.
    
    def get_messages_from_thread(self, thread_id:str, run_id:str, timeout:int) -> list:
        logging.info("Running get_messages_from_thread")
        self.wait_loop(thread_id=thread_id, run_id=run_id, timeout=timeout)

        thread_messages = self.client.beta.threads.messages.list(thread_id=thread_id).data
        logging.debug(f"THREAD_MESSAGES: {thread_messages}")
        latest_assistant_messages = self.get_latest_assistant_message(thread_messages)

        messages_text = self.get_messages_texts(latest_assistant_messages=latest_assistant_messages)
    
    def process_interrogation(self, assistant_name:str, message:str, thread_id:str) -> None:
        self.add_message_to_thread(message, thread_id)
        run_id = self.run_assistant(assistant_name, thread_id)
        messages = self.get_messages_from_thread(thread_id, run_id, 120)
        return [re.sub(r"【.*?】", "", message) for message in messages]