from google.cloud import documentai_v1 as documentai
from google.cloud import storage
import os
import re
from google.api_core.client_options import ClientOptions
import logging

class Pdf_Transformer:
    """
    Transform the pdf file into text
    """
    def __init__(self, id_pratica:int, file_name:str, file_bytes:bytes, account_name:str, logger:logging.Logger):
        self.id_pratica = id_pratica
        self.file_name = file_name
        self.file_name_no_ext = os.path.splitext(file_name)[0]
        self.file_bytes = file_bytes
        self.account_name = account_name
        self.logger = logger

    def process_pdf(self):
        """
        Entrypoit for the class.
        """
        # Document AI client, project ID, location, and processor ID
        project_id = 'lawli-bab83'
        bucket_name = "lawli-bab83.appspot.com"
        location = 'eu'
        processor_id = 'a1de2c755caca3e6' 

        opts = ClientOptions(api_endpoint=f"{location}-documentai.googleapis.com")
        client = documentai.DocumentProcessorServiceClient(client_options=opts)

        source_uri = f"gs://{project_id}.appspot.com/accounts/{self.account_name}/pratiche/{str(self.id_pratica)}/documenti/originale_{self.file_name}"
        destination_uri = f"gs://{project_id}.appspot.com/accounts/{self.account_name}/pratiche/{str(self.id_pratica)}/documenti/{self.file_name}_docai"
        destination_txt = f"accounts/{self.account_name}/pratiche/{str(self.id_pratica)}/documenti/{self.file_name_no_ext}.txt"

        # Configure API Endpoint (may be needed for some setups)
        gcs_document = documentai.GcsDocument(gcs_uri=source_uri, mime_type="application/pdf")
        gcs_documents = documentai.GcsDocuments(documents=[gcs_document])
        input_config = documentai.BatchDocumentsInputConfig(gcs_documents=gcs_documents)
        gcs_output_config = documentai.DocumentOutputConfig.GcsOutputConfig(gcs_uri=destination_uri)
        output_config = documentai.DocumentOutputConfig(gcs_output_config=gcs_output_config)

        name = client.processor_path(project_id, location, processor_id)
        request = documentai.BatchProcessRequest(name=name, input_documents=input_config, document_output_config=output_config)

        operation = client.batch_process_documents(request=request)
        self.logger.info(f"Operation started")

        operation.result(timeout=180)

        metadata = documentai.BatchProcessMetadata(operation.metadata)

        if metadata.state != documentai.BatchProcessMetadata.State.SUCCEEDED:
            raise ValueError(f"Batch Process Failed: {metadata.state_message}")
        
        individual_process_statuses = metadata.individual_process_statuses

        for process in individual_process_statuses:
            matches = re.match(r"gs://(.*?)/(.*)", process.output_gcs_destination)
            if not matches:
                self.logger.error(f"Could not parse output GCS destination:{process.output_gcs_destination}")
                continue
            else:
                self.logger.info(f"Processing output GCS destination: {process.output_gcs_destination}")

            output_bucket, output_prefix = matches.groups()
            storage_client = storage.Client()
            output_blobs = storage_client.list_blobs(output_bucket, prefix=output_prefix)
            for blob in output_blobs:
                if ".json" not in blob.name:
                    self.logger.warning(f"Skipping non-supported file: {blob.name} - Mimetype: {blob.content_type}")
                    continue

                self.logger.info(f"Fetching {blob.name}")
                document = documentai.Document.from_json(
                    blob.download_as_bytes(), ignore_unknown_fields=True
                )

                extracted_text = document.text

                self.logger.info(f"Extracted text: {extracted_text}")
                blob_txt = storage_client.bucket(bucket_name).blob(destination_txt)
                blob_txt.upload_from_string(extracted_text, content_type="text/plain; charset=utf-8")

                # Delete the file from the bucket
                try:
                    blob.delete()
                    self.logger.info(f"Deleted file: {blob.name}")
                except Exception as e:
                    self.logger.error(f"Error deleting file: {blob.name} - {e}")
                    raise e