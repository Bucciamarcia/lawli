import logging
from firebase_functions import https_fn
from datetime import datetime


class Upload_Document:
    def __init__(self, req:https_fn.Request, logger: logging.Logger):
        self.req = req
        self.logger = logger
        data = req.json["data"]
        id_pratica = data["idPratica"]
        datastring = data["data"]
        datetime_object = datetime.strptime(datastring, '%Y-%m-%d')
        filename = data["filename"]
        filecontent = data["file"]

    def main(self):
        self.logger.info("Starting upload_document")

        return "ok"