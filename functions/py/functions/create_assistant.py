from openai import OpenAI, OpenAIError
import os
from py.constants import CREATE_ASSISTANT_ENGINE, CREATE_ASSISTANT_INSTRUCTIONS
from py.commons import Cloud_Storege_Util
from py.logger_config import LoggerConfig
from io import BytesIO


class Create_Assistant:
    def __init__(self):
        self.logger = LoggerConfig().setup_logging()
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.engine = CREATE_ASSISTANT_ENGINE
        self.doc_id_path = "accounts/lawli/pratiche/1/documenti/{assistant_name}.txt"

    def upload_document(self, blob_name: str) -> str:
        try:
            filebytes = Cloud_Storege_Util().get_file_bytes(blob_name)
            file_like_object = BytesIO(filebytes)
            file_like_object.name = "nometest.pdf"
        except Exception as e:
            self.logger.error(f"Error while reading file: {e}")
            raise Exception(f"Error while reading file: {e}")
        try:
            response = self.client.files.create(
                file=file_like_object,
                purpose="assistants"
            )
            self.logger.info("Document uploaded successfully")
            return response.id
        except OpenAIError as e:
            self.logger.error(f"OpenAI error while uploading document: {e}")
            raise OpenAIError(f"OpenAI error while uploading document: {e}")
        except Exception as e:
            self.logger.error(f"Error while uploading document: {e}")
            raise Exception(f"Error while uploading document: {e}")
    
    def strip_extension(self, filename: str):
        return os.path.splitext(filename)[0]

    def process_assistant(self, assistant_name: str) -> str:
        """
        Entrypoint. Creates the assistant with the given name.
        """
        assistant_name_no_ext = self.strip_extension(assistant_name)
        document_id = self.upload_document(
            self.doc_id_path.format(assistant_name=assistant_name_no_ext)
        )
        try:
            my_assistant = self.client.beta.assistants.create(
                model=self.engine,
                name=assistant_name,
                file_ids=[document_id],
                tools=[{"type": "retrieval"}],
                instructions=CREATE_ASSISTANT_INSTRUCTIONS
            )
            self.logger.info(f"MY_ASSISTANT: {my_assistant}")
            return my_assistant.id
        except OpenAIError as e:
            self.logger.error(f"OpenAI Error while creating assistant: {e}")
            raise OpenAIError(f"OpenAI Error while creating assistant: {e}")
        except Exception as e:
            self.logger.error(f"Error while creating assistant: {e}")
            raise Exception(f"Error while creating assistant: {e}")
