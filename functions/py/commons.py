"""
Common operations shared by multiple functions.
"""

from firebase_functions import https_fn
import logging
from google.cloud import storage
from py.constants import *


def get_data(req:https_fn.CallableRequest, logger:logging.Logger, keys:list) -> tuple:
    """
    Extract the data from the request and return it as a tuple.
    """
    try:
        data = req.data
    except Exception as e:
        logger.error(f"Error while extracting data from request: {e}")
        raise f"Error while extracting data from request: {e}"

    return tuple(data[key] for key in keys)

class Cloud_Storege_Util:
    """
    Utility class for Cloud Storage operations.
    """
    def __init__(self, logger:logging.Logger):
        self.logger = logger
        try:
            self.storage_client = storage.Client()
            self.bucket = self.storage_client.bucket(BUCKET_NAME)
        except Exception as e:
            self.logger.error(f"Error while initializing storage client: {e}")
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
            self.logger.error(f"Error while reading text file: {e}")
            raise f"Error while reading text file: {e}"