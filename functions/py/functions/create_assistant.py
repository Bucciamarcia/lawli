from openai import OpenAI, OpenAIError
import os
from py.constants import CREATE_ASSISTANT_ENGINE, CREATE_ASSISTANT_INSTRUCTIONS
from py.commons import Cloud_Storege_Util
from py.logger_config import LoggerConfig
from io import BytesIO
from time import sleep


class Create_Assistant:
    def __init__(self, pratica_id: str):
        self.logger = LoggerConfig().setup_logging()
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.engine = CREATE_ASSISTANT_ENGINE
        self.temp = f"accounts/lawli/pratiche/{pratica_id}/documenti/"
        self.doc_id_path = f"{self.temp}{{assistant_name}}.txt"

    def vector_store_upload(self, blob_name: str, assistant_name: str) -> str:
        try:
            filebytes = Cloud_Storege_Util().get_file_bytes(blob_name)
            file_like_object = BytesIO(filebytes)
            file_like_object.name = blob_name
        except Exception as e:
            self.logger.error(f"Error while reading file: {e}")
            raise Exception(f"Error while reading file: {e}")
        try:
            vector_store = self.client.beta.vector_stores.create(
                name=assistant_name
            )
            file_batch = self.client.beta.vector_stores.file_batches.upload_and_poll(
                vector_store_id=vector_store.id, files=[file_like_object]
            )
            n = 0
            while n < 10:
                self.logger.info(f"Batch status: {file_batch.status}")
                if file_batch.status == "completed":
                    return vector_store.id
                sleep(5)

            response = self.client.files.create(
                file=file_like_object, purpose="assistants"
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
        self.logger.info(f"Creating assistant with name: {assistant_name}")
        assistant_name_no_ext = self.strip_extension(assistant_name)
        vector_store_id = self.vector_store_upload(
            self.doc_id_path.format(assistant_name=assistant_name_no_ext),
            assistant_name=assistant_name
        )
        try:
            my_assistant = self.client.beta.assistants.create(
                model=self.engine,
                name=assistant_name,
                tools=[{"type": "file_search"}],
                tool_resources={"file_search": {"vector_store_ids": [vector_store_id]}},
                instructions=CREATE_ASSISTANT_INSTRUCTIONS,
            )
            self.logger.info(f"MY_ASSISTANT: {my_assistant}")
            return my_assistant.id
        except OpenAIError as e:
            self.logger.error(f"OpenAI Error while creating assistant: {e}")
            raise OpenAIError(f"OpenAI Error while creating assistant: {e}")
        except Exception as e:
            self.logger.error(f"Error while creating assistant: {e}")
            raise Exception(f"Error while creating assistant: {e}")
