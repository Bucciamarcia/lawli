import logging
import json

class Generated_Document:
    def __init__(self, logger:logging.Logger, payload:str, object_id:str):
        self.logger = logger
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e
        
    def process_document(self) -> str:
        """Process the document."""
        pass
        return "ok"