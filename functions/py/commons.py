"""
Common operations shared by multiple functions.
"""

from firebase_functions import https_fn
from py.constants import *
from google.cloud import storage
from firebase_admin import firestore
from py.logger_config import logger


def get_data(req:https_fn.CallableRequest, keys:list) -> tuple:
    """
    Extract the data from the request and return it as a tuple.
    """
    logger.info(f"REQ DATA: {req.data}")
    logger.info(f"KEYS: {keys}")
    try:
        data = req.data
    except Exception as e:
        logger.error(f"Error while extracting data from request: {e}")
        raise f"Error while extracting data from request: {e}"

    return tuple(data[key] for key in keys)

def check_ext(filename:str) -> bool:
    """Check if the file is a txt file."""
    if filename.endswith(".txt"):
        return True
    else:
        return False

class Cloud_Storege_Util:
    """
    Utility class for Cloud Storage operations.
    """
    def __init__(self):
        try:
            self.storage_client = storage.Client()
            self.bucket = self.storage_client.bucket(BUCKET_NAME)
        except Exception as e:
            logger.error(f"Error while initializing storage client: {e}")
            raise f"Error while initializing storage client: {e}"

    
    def read_text_file(self, blob_name: str) -> str:
        """
        Read a text file from the bucket.
        Returns the content of the file.
        """
        try:
            blob = self.bucket.blob(blob_name)
            with blob.open("r") as f:
                return f.read()
        except Exception as e:
            logger.error(f"Error while reading text file: {e}")
            raise f"Error while reading text file: {e}"
    
    def get_file_bytes(self, blob_name: str) -> bytes:
        """
        Read a file from the bucket.
        Returns the content of the file as bytes.
        """
        try:
            blob = self.bucket.blob(blob_name)
            logger.info(f"BLOB READ CORRECTLY: {blob}")
            return blob.download_as_bytes()
        except Exception as e:
            logger.error(f"Error while reading file: {e}")
            raise f"Error while reading file: {e}"
    
    def write_text_file(self, blob_name: str, content: str) -> None:
        """
        Write a text file to the bucket.
        ## FORMAT BLOB NAME:
        "path/to/file.txt"
        """
        try:
            blob = self.bucket.blob(blob_name)
            blob.upload_from_string(content, content_type="text/plain; charset=utf-8")
        except Exception as e:
            logger.error(f"Error while writing text file: {e}")
            raise f"Error while writing text file: {e}"

class Firestore_Util:
    """
    Utility class for Firestore operations.
    """
    def __init__(self):
        try:
            self.db = firestore.client()
        except Exception as e:
            logger.error(f"Error while initializing firestore client: {e}")
            raise f"Error while initializing firestore client: {e}"
    
    def write_to_firestore(self, data: dict, merge: bool, path:str) -> None:
        """
        Write data to Firestore.
        """
        try:
            ref = self.db.document(path)
            ref.set(data, merge=merge)
        except Exception as e:
            logger.error(f"Error while writing to Firestore: {e}")
            raise f"Error while writing to Firestore: {e}"
    
    def search_document(self, path:str, filename:str) -> str:
        ref = self.db.collection(path).get()
        for doc in ref:
            doc_dict = doc.to_dict()
            if filename in doc_dict["filename"]:
                return doc_dict["filename"]