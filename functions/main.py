# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app
import google.cloud.logging
import logging
from py import commons
from time import sleep
from py.functions.upload_document import Upload_Document

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

# Add console logger
consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(formatter)
logger.addHandler(consoleHandler)

@https_fn.on_request()
def upload_document(req: https_fn.Request) -> https_fn.Response:
    
    # Add CORS headers
    if req.method == 'OPTIONS':
        return commons.cors_headers_preflight(req)

    response = Upload_Document(req, logger).main()
    sleep(3)

    return commons.cors_headers(https_fn.Response(response, status=500, headers={"Content-Type": "application/json"}))