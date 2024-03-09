"""
Common operations shared by multiple functions.
"""

from firebase_functions import https_fn
import logging
from google.cloud import storage
import constants


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
        self.storage_client = storage.Client()
        self.bucket_name = constants.BUCKET_NAME
        self.bucket = self.storage_client.create_bucket(self.bucket_name)