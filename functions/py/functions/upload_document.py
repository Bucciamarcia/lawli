import logging
from firebase_functions import https_fn
from datetime import datetime
from .. import constants
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore



class New_Document:
    def __init__(self, req:https_fn.Request, logger: logging.Logger):
        self.req = req
        self.logger = logger
        try:
            data = req.data

            self.id_pratica = data["idPratica"]
            self.account_name = data["accountName"]
            self.datastring = data["data"]
            self.datetime_object = datetime.strptime(self.datastring, '%Y-%m-%d')
            self.filename = data["filename"]
            self.filecontent = data["file"]
        except Exception as e:
            self.logger.error(f"Error while parsing request data: {e}")
            raise ValueError(f"Error while parsing request data: {e}")
        
    def init_firestore(self) -> firestore.client:
        db = firestore.client()
        return db

    
    def firestore_upload(self):
        """
        Upload the new document to Firestore.
        """
        self.logger.info("Uploading to Firestore")

        db = self.init_firestore()
        doc = {
            "data": self.datetime_object,
            "filename": self.filename        
        }

        try:
            docs = db.collection("accounts").document(self.account_name).collection("pratiche").document(str(self.id_pratica)).collection("documenti").document(self.filename)
            docs.set(doc)
        except Exception as e:
            self.logger.error(f"Error while setting document to Firestore: {e}")
            raise ValueError(f"Error while setting document to Firestore: {e}")
    
    def upload_storage(self):
        """
        Upload the new document to Firebase Storage.
        """
        self.logger.info("Uploading to Storage")
        

    def upload_document(self):
        """
        Upload the new document to Firestore. Entrypoint for the Cloud Function.
        """
        self.logger.info("Starting upload_document")

        self.firestore_upload()

        return constants.SUCCESS_RESPONSE