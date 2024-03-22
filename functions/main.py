# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from cloudevents.http import CloudEvent
import os
from firebase_admin import initialize_app
from py.functions import *
from py import commons
import functions_framework
import base64
import logging
from py.logger_config import logger

initialize_app()

@https_fn.on_call()
def get_text_from_pdf(req: https_fn.CallableRequest) -> dict[str, str]:

    logger.info("get_text_from_pdf called")

    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, logger, keys)

    result = Pdf_Transformer(id_pratica, file_name, file_bytes, account_name, logger).process_pdf()
    pass

    return {"status": "ok"}

@https_fn.on_call()
def does_assistant_exist(req: https_fn.CallableRequest) -> bool:
    logger.info("does_assistant_exist called")
    keys = ["assistantName"]
    assistant_name, = commons.get_data(req, logger, keys)
    result = Does_Assistant_Exist().process_assistant(assistant_name)
    return result

@https_fn.on_call()
def create_assistant(req: https_fn.CallableRequest) -> bool:
    logger.info("create_assistant called")
    keys = ["assistantName"]
    assistant_name, = commons.get_data(req, logger, keys)
    logger.info(f"ASSISTANT_ID: {assistant_name}")
    result = Create_Assistant().process_assistant(assistant_name)
    return result

@https_fn.on_call()
def create_thread(req: https_fn.CallableRequest) -> str:
    logger.info("create_thread called")
    return Create_Thread().create_thread()

@https_fn.on_call()
def interrogate_chatbot(req: https_fn.CallableRequest) -> str:
    logger.info("interrogate_chatbot called")
    logger.info(f"REQUEST: {req}")
    keys = ['assistantName', 'assistantId', 'message', 'threadId']
    assistant_name, assistant_id, message, thread_id = commons.get_data(req, logger, keys)
    return Interrogate_Chatbot().process_interrogation(assistant_name, assistant_id, message, thread_id)

@functions_framework.cloud_event
def get_txt_from_docai_json(event: CloudEvent) -> dict[str, str]:
    logger.info("on_pubsub_message called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    
    result = Json_Transformer(decoded, object_id).process_json()

    return {"status": "ok"}

@functions_framework.cloud_event
def generate_document_summary(event: CloudEvent) -> dict[str, str]:
    logger.info("generate_document_summary called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    filename = os.path.basename(object_id)
    is_txt = commons.check_ext(filename)

    if is_txt:
        result_1 = Generated_Document(decoded, object_id).process_document()
        result_2 = Brief_Description(decoded, object_id).process_brief_description()

    return {"status": "ok"}