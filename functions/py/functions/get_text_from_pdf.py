from google.cloud import documentai_v1 as documentai
import os
from .. import constants
from google.api_core.client_options import ClientOptions
from py.logger_config import LoggerConfig


class Pdf_Transformer:
    """
    Transform the pdf file into text
    """

    def __init__(
        self, id_pratica: int, file_name: str, file_bytes: bytes, account_name: str
    ):
        self.id_pratica = id_pratica
        self.file_name = file_name
        self.logger = LoggerConfig().setup_logging()
        self.file_name_no_ext = os.path.splitext(file_name)[0]
        self.file_bytes = file_bytes
        self.account_name = account_name

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

        source_uri = f"gs://{project_id}.appspot.com/accounts/{self.account_name}/pratiche/{str(self.id_pratica)}/documenti/originale_{self.file_name}"
        destination_uri = f"gs://{project_id}.appspot.com/accounts/{self.account_name}/pratiche/{str(self.id_pratica)}/documenti/{self.file_name}_docai"

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

        client.batch_process_documents(request=request)
        self.logger.info("Operation started")
