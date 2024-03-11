import logging
import json
import os
from ... import commons
import libreria_ai_per_tutti as ai
from py.commons import *

class Brief_Description:
    def __init__(self, logger:logging.Logger, payload:str, object_id:str):
        self.logger = logger
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e
        self.filename = os.path.basename(self.object_id)
        self.pathname = os.path.dirname(self.object_id)
        self.praticapath = os.path.dirname(self.pathname)

    def process_brief_description(self) -> str:
        """Entrypoint of the function. Process the brief description."""
        pass