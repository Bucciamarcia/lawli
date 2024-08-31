from google.cloud import documentai_v1 as documentai
from .. import constants
from google.api_core.client_options import ClientOptions
from py.logger_config import LoggerConfig


class Pdf_Transformer:
    """
    Transform the pdf file into text
    """

    def __init__(self, path: str, file_bytes: bytes):
        self.path = path
        self.logger = LoggerConfig().setup_logging()
        self.file_bytes = file_bytes

    def process_pdf(self):
        """
        Entrypoit for the class.
        """
        # Document AI client, project ID, location, and processor ID
        project_id = constants.PROJECT_ID
        location = "eu"
        processor_id = "a1de2c755caca3e6"

        opts = ClientOptions(api_endpoint=f"{location}-documentai.googleapis.com")
        client = documentai.DocumentProcessorServiceClient(client_options=opts)
        source_uri = self.path
        destination_uri = f"{self.path}_docai"

        # Configure API Endpoint (may be needed for some setups)
        gcs_document = documentai.GcsDocument(
            gcs_uri=source_uri, mime_type="application/pdf"
        )
        gcs_documents = documentai.GcsDocuments(documents=[gcs_document])
        input_config = documentai.BatchDocumentsInputConfig(gcs_documents=gcs_documents)
        gcs_output_config = documentai.DocumentOutputConfig.GcsOutputConfig(
            gcs_uri=destination_uri
        )
        output_config = documentai.DocumentOutputConfig(
            gcs_output_config=gcs_output_config
        )

        name = client.processor_path(project_id, location, processor_id)
        request = documentai.BatchProcessRequest(
            name=name,
            input_documents=input_config,
            document_output_config=output_config,
        )

        max_tries = 3
        initial_timeout_seconds = 10
        incremental_timeout_seconds = 5
        tries = 0
        while tries < max_tries:
            try:
                operation = client.batch_process_documents(request=request)
                operation.result(timeout=initial_timeout_seconds)
                break
            except Exception as e:
                self.logger.error(f"Error in client.batch_process_documents: {e}")
                tries += 1
                initial_timeout_seconds += incremental_timeout_seconds
        self.logger.info("Operation started")
