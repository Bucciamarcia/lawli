from py.logger_config import LoggerConfig
from docx import Document
import io
import base64


class DocxCreator:
    def __init__(self, text: str):
        self.text = text
        self.logger = LoggerConfig().setup_logging()

    def create_docx(self) -> str:
        doc = Document()
        doc.add_paragraph(self.text)
        stream = io.BytesIO()
        doc.save(stream)
        doc_bytes = stream.getvalue()
        stream.close()
        doc_bytearray = bytearray(doc_bytes)
        encoded_doc = base64.b64encode(doc_bytearray).decode("utf-8")
        return encoded_doc
