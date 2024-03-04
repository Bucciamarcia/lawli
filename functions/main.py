# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from cloudevents.http import CloudEvent
from firebase_admin import initialize_app
import google.cloud.logging
import logging
from py.functions.get_text_from_pdf import Pdf_Transformer
from py.functions.get_txt_from_docai_json import Json_Transformer
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
def get_text_from_pdf(req: https_fn.CallableRequest) -> dict:

    logger.info("get_text_from_pdf called")

    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, logger, keys)

    result = Pdf_Transformer(id_pratica, file_name, file_bytes, account_name, logger).process_pdf()
    pass

    return {"status": "ok"}

@functions_framework.cloud_event
def get_txt_from_docai_json(event: CloudEvent) -> dict[str, str]:
    print("TEST PRINT - STARTING LOGGING")
    logger.info("on_pubsub_message called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    
    result = Json_Transformer(logger, decoded, object_id).process_json()

    return {"status": "ok"}