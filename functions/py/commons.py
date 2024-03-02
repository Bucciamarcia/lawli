"""
Common operations shared by multiple functions.
"""

from firebase_functions import https_fn
import logging

def get_data(req:https_fn.CallableRequest, logger:logging.Logger, keys:list) -> tuple:
    """
    Extract the data from the request and return it as a tuple.
    """
    data = req.data
    logger.info(f"Data received: {data}")
    return tuple(data[key] for key in keys)