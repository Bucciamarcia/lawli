import json
from google.cloud import storage, documentai_v1 as documentai
from py.logger_config import LoggerConfig
from .. import constants

class Json_Transformer:
    def __init__(self, payload:str, object_id:str):
        self.logger = LoggerConfig().setup_logging()
        try:
            self.payload = json.loads(payload)
            self.object_id = object_id
        except Exception as e:
            self.logger.error(f"Error loading json: {e}")
            raise e

    def check_docai(self):
        """Check if the json is from Document AI."""
        if "_docai" in self.payload["name"]:
            return True
        else:
            return False
        
    def extract_text_from_json(self) -> str:
        """Transform the Document AI json into a txt file."""
        client = storage.Client()
        bucket = client.bucket(self.payload["bucket"])
        blob = bucket.blob(self.payload["name"])
        
        document = documentai.Document.from_json(
            blob.download_as_bytes(), ignore_unknown_fields=True
        )

        extracted_text = document.text

        self.logger.info(f"Extracted text: {extracted_text}")

        return extracted_text
    
    def get_blobname(self) -> str:
        """Get the blob of the bucket."""
        extracted_text = self.object_id.split(".pdf_docai")[0]


        if extracted_text:
            return f"{extracted_text}.txt"
        
        else:
            self.logger.error(f"Error getting blob name: {self.object_id}")
            raise ValueError(f"Error getting blob name: {self.object_id}")
    
    def upload_blob(self, bucket_name:str, text:str, destination_blob_name:str):
        """Upload the blob to the bucket."""
        try:
            storage_client = storage.Client()
            bucket = storage_client.get_bucket(bucket_name)
            blob = bucket.blob(destination_blob_name)
            blob.upload_from_string(text, content_type="text/plain; charset=utf-8")
            self.logger.info(f"File {destination_blob_name} uploaded to {bucket_name}.")
        except Exception as e:
            self.logger.error(f"Error uploading blob: {e}")
            raise e
    
    def delete_json_blob(self):
        """Delete the json blob from the bucket."""
        try:
            storage_client = storage.Client()
            bucket = storage_client.get_bucket(self.payload["bucket"])
            blob = bucket.blob(self.payload["name"])
            blob.delete()
            self.logger.info(f"File {self.payload['name']} deleted from {self.payload['bucket']}.")
        except Exception as e:
            self.logger.error(f"Error deleting json blob: {e}")
            raise e


    def process_json(self):
        """Entrpoint for the class."""
        self.logger.info(f"Processing json: {self.payload}\n\nObject ID: {self.object_id}")
        
        is_doc_from_docai = self.check_docai()

        if is_doc_from_docai:
            self.logger.info(f"Document is from Document AI")
            text = self.extract_text_from_json()
            blob_name = self.get_blobname()
            self.upload_blob(constants.BUCKET_NAME, text, blob_name)
            self.delete_json_blob()
        
        else:
            self.logger.info(f"Document is not from Document AI - exiting.")
            return