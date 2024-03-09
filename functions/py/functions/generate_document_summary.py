import logging
import json
import os

class Generated_Document:
    def __init__(self, logger:logging.Logger, payload:str, object_id:str):
        self.logger = logger
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e
        self.filename = os.path.basename(self.object_id)
        
    def check_ext(self):
        """Check if the file is a txt file."""
        if self.filename.endswith(".txt"):
            return True
        else:
            return False
        
    def process_document(self) -> str:
        """Process the document."""
        
        if self.check_ext():
            self.logger.info(f"File {self.object_id} is a txt file. Processing...")
            return
        else:
            self.logger.info(f"File {self.object_id} is not a txt file - exiting.")
            return