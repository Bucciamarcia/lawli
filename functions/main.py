# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from cloudevents.http import CloudEvent
import os
from firebase_admin import initialize_app
import google.cloud.logging
import logging
from py.functions.get_text_from_pdf import Pdf_Transformer
from py.functions.get_txt_from_docai_json import Json_Transformer
from py.functions.generate_document_summary import Generated_Document
from py.functions.generate_brief_description import Brief_Description
from py import commons
import functions_framework
import base64

initialize_app()

# Initialize cloud logger
client = google.cloud.logging.Client()
handler = client.get_default_handler()
client.setup_logging()
logger = logging.getLogger("cloudLogger")
logger.setLevel(logging.INFO)
logger.addHandler(handler)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)


@https_fn.on_call()
def get_text_from_pdf(req: https_fn.CallableRequest) -> dict[str, str]:

    logger.info("get_text_from_pdf called")

    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, logger, keys)

    result = Pdf_Transformer(id_pratica, file_name, file_bytes, account_name, logger).process_pdf()
    pass

    return {"status": "ok"}

@functions_framework.cloud_event
def get_txt_from_docai_json(event: CloudEvent) -> dict[str, str]:
    logger.info("on_pubsub_message called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    
    result = Json_Transformer(logger, decoded, object_id).process_json()

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
        result_1 = Generated_Document(logger, decoded, object_id).process_document()
        result_2 = Brief_Description(logger, decoded, object_id).process_brief_description()

    return {"status": "ok"}