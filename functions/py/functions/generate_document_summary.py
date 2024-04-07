import json
import os
from .. import commons
import libreria_ai_per_tutti as ai
from py.commons import *


class Generated_Document:
    def __init__(self, payload:str, object_id:str):
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            raise e
        self.filename = os.path.basename(self.object_id)
        self.pathname = os.path.dirname(self.object_id)
        self.praticapath = os.path.dirname(self.pathname)
    
    def get_summary(self, text):
        """
        Uses the GPT engine to create a summary of the legal document.
        """
        messages=[
            {
                "role": "system",
                "content": DOCUMENT_SUMMARY_GPT_MESSAGE
            },
            {
                "role": "user",
                "content": text
            }
        ]
        try:
            summary = ai.gpt_call(messages=messages, engine=SUMMARY_ENGINE, temperature=0, apikey=os.environ.get("OPENAI_APIKEY"))
        except Exception as e:
            raise f"Error while summarizing the file: {e}"

        return summary
    
    def get_blob_output_name(self):
        """Get the name of the output blob."""
        if "originale_" in self.filename:
            return self.filename.replace("originale_", "")
        else:
            return self.filename
        
    def process_document(self) -> str:
        """Process the document."""
        
        text = commons.Cloud_Storege_Util().read_text_file(self.object_id)
        summary = self.get_summary(text)
        blob_filename = self.get_blob_output_name()
        commons.Cloud_Storege_Util().write_text_file(f"{self.praticapath}/riassunti/{blob_filename}", summary)   
        return
