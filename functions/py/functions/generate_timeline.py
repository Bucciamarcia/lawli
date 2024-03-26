import json
from openai import OpenAI
from py.commons import *
from py.constants import *

class TimelineGenerator:
    """
    Class that generates a timeline for a client.
    """
    def __init__(self, assistito_name:str, pratica_id: str):
        self.assistito_name = assistito_name
        self.pratica_id = pratica_id
        self.client = OpenAI(api_key=OPENAI_API_KEY)

    def get_document_content(self, doc_id: str) -> str:
        """
        Get the content of a document from Firestore.
        """
        try:
            doc = Firestore_Util().search_document(
                path=f"assistiti/{self.assistito_name}/pratiche/{self.pratica_id}/documenti",
                filename=doc_id
            )
            return doc["text"]
        except Exception as e:
            logger.error(f"Error while getting document content: {e}")
            raise f"Error while getting document content: {e}"

    def get_documents(self) -> list[str]:
        """
        Get all the files for the client. Returns a list of all the documents.
        """
        doc_ids = Firestore_Util().get_all_document_ids(assistito=self.assistito_name, pratica=self.pratica_id)
        documents = []
        for doc_id in doc_ids:
            documents.append(self.get_document_content(doc_id))
        return documents
    
    def get_document_timeline(self, dict, doc) -> dict:
        try:
            response = self.client.chat.completions.create(
                model=GENERATE_TIMELINE_ENGINE,
                response_format= {"type": "json"},
                messages= [
                    {"role": "system", "content": GENERATE_TIMELINE_FIRST_PROMPT},
                    {"role": "user", "content": doc}
                ],
                temperature=0
            )
        except:
            logger.error(f"Error while generating timeline for document: {doc}")
            raise f"Error while generating timeline for document: {doc}"
        
        return(json.loads(response.choices[0].message.content))


    def generate_timeline(self) -> dict[str, str]:
        """
        Entrypoint for the function. Generates a timeline for the client and returns it as a string.
        """
        documents = self.get_documents()
        timeline = {}
        for doc in documents:
            timeline.update(self.get_document_timeline(timeline, doc))
            #TODO: Da qui.