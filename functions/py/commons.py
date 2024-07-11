"""
Common operations shared by multiple functions.
"""

from firebase_functions import https_fn
from py.constants import BUCKET_NAME
from google.cloud import storage
from firebase_admin import firestore
import os
import re
from py.logger_config import LoggerConfig


def get_data(req: https_fn.CallableRequest, keys: list) -> tuple:
    """
    Extract the data from the request and return it as a tuple.
    """
    logger = LoggerConfig().setup_logging()
    logger.info(f"REQ DATA: {req.data}")
    logger.info(f"KEYS: {keys}")
    try:
        data = req.data
    except Exception as e:
        logger.error(f"Error while extracting data from request: {e}")
        raise Exception(f"Error while extracting data from request: {e}")

    return tuple(data[key] for key in keys)


def check_ext(filename: str) -> bool:
    """Check if the file is a txt file."""
    if filename.endswith(".txt"):
        return True
    else:
        return False


def change_ext_to_txt(filename: str) -> str:
    """
    Change the extension of the file to .txt.
    If the file is already a .txt file, return the filename as is.
    """
    ext = os.path.splitext(filename)[1]
    if ext == ".txt":
        return filename
    else:
        filename_no_ext = os.path.splitext(filename)[0]
        return f"{filename_no_ext}.txt"


def check_is_document(path: str) -> bool:
    """
    Check if the pattern corresponds to a document.
    """
    pattern = r"^accounts/[^/]+/pratiche/[^/]+/documenti/[^/]+(/.*)?$"
    match = re.match(pattern, path)
    if match:
        return True
    else:
        return False


class Cloud_Storege_Util:
    """
    Utility class for Cloud Storage operations.
    """

    def __init__(self):
        self.logger = LoggerConfig().setup_logging()
        try:
            self.storage_client = storage.Client()
            self.bucket = self.storage_client.bucket(BUCKET_NAME)
        except Exception as e:
            self.logger.error(f"Error while initializing storage client: {e}")
            raise Exception(f"Error while initializing storage client: {e}")

    def read_text_file(
        self,
        blob_name: str | None = None,
        account_name: str | None = None,
        pratica_id: str | None = None,
        document_id: str | None = None,
    ) -> str:
        """
        Read a text file from the bucket.
        Returns the content of the file.
        If blob_name is specified, then it is used.
        Otherwise, account_name, pratica_id, and document_id are used.
        """
        if blob_name:
            try:
                blob = self.bucket.blob(blob_name)
                with blob.open("r") as f:
                    return str(f.read())
            except Exception as e:
                self.logger.error(f"Error while reading text file: {e}")
                raise Exception(e)
        elif account_name and pratica_id and document_id:
            blob_name = (
                f"accounts/{account_name}/pratiche/{pratica_id}/documenti/{document_id}"
            )
            try:
                blob = self.bucket.blob(blob_name)
                with blob.open("r") as f:
                    return str(f.read())
            except Exception as e:
                self.logger.error(f"Error while reading text file: {e}")
                raise Exception(e)
        else:
            raise Exception("No arguments provided")

    def get_file_bytes(self, blob_name: str) -> bytes:
        """
        Read a file from the bucket.
        Returns the content of the file as bytes.
        """
        try:
            blob = self.bucket.blob(blob_name)
            self.logger.info(f"BLOB READ CORRECTLY: {blob}")
            return blob.download_as_bytes()
        except Exception as e:
            self.logger.error(f"Error while reading file: {e}")
            raise Exception(f"Error while reading file: {e}")

    def write_text_file(self, blob_name: str, content: str) -> None:
        """
        Write a text file to the bucket.
        ## FORMAT BLOB NAME:
        "path/to/file.txt"
        """
        try:
            blob = self.bucket.blob(blob_name)
            blob.upload_from_string(
                content,
                content_type="text/plain; \
            charset=utf-8",
            )
        except Exception as e:
            self.logger.error(f"Error while writing text file: {e}")
            raise Exception(f"Error while writing text file: {e}")


class Firestore_Util:
    """
    Utility class for Firestore operations.
    """

    def __init__(self):
        self.logger = LoggerConfig().setup_logging()
        try:
            self.db = firestore.client()
        except Exception as e:
            self.logger.error(f"Error while initializing firestore client: {e}")
            raise Exception(e)

    def write_to_firestore(self, data: dict, merge: bool, path: str) -> None:
        """
        Write data to Firestore.
        """
        self.logger.info(f"Writing to Firestore: {data} - {path}")
        try:
            ref = self.db.document(path)
            ref.set(data, merge=merge)
        except Exception as e:
            self.logger.error(f"Error while writing to Firestore: {e}")
            raise Exception(f"Error while writing to Firestore: {e}")

    def search_document(self, path: str, filename: str) -> str | None:
        ref = self.db.collection(path).get()
        for doc in ref:
            doc_dict = doc.to_dict()
            if filename in doc_dict["filename"]:
                return doc_dict["filename"]

    def get_document(self, path: str) -> dict | None:
        ref = self.db.document(path)
        doc = ref.get()
        return doc.to_dict()

    def get_all_document_ids(self, assistito: str, pratica: str) -> list[str]:
        """
        Get all the document IDs"""
        docs = self.db.collection(
            f"accounts/{assistito}/pratiche/{pratica}/documenti"
        ).stream()
        documents = []
        for doc in docs:
            documents.append(doc.id)
        return documents
