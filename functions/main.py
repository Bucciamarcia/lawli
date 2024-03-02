# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app
import google.cloud.logging
import logging
from py import commons

initialize_app()

# Initialize stdout and cloud logger
client = google.cloud.logging.Client()
logger = client.logger("my-log-name")
handler = google.cloud.logging.handlers.CloudLoggingHandler(client)
logger = logging.getLogger("cloudLogger")
logger.setLevel(logging.INFO)
logger.addHandler(handler)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

@https_fn.on_call()
def get_text_from_new_document(req: https_fn.CallableRequest) -> dict:
    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, logger, keys)

    logging.info(f"Received data: {id_pratica}, {file_name}, {file_bytes}, {account_name}")

    return {"status": "ok"}