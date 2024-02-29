# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app
import google.cloud.logging
import logging
from py import commons
import json
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
    
    # Sleep for 1 second to simulate a slow function
    sleep(3)

    response = Upload_Document(req, logger).main()
    response_data = json.dumps({"data": {"result": "OK"}})

    return commons.cors_headers(https_fn.Response(response_data, status=500, headers={"Content-Type": "application/json"}))