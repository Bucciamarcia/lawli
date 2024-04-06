from py.logger_config import LoggerConfig
from openai import OpenAI, OpenAIError
import os
import weaviate
import weaviate.classes as wvc


class SentenzeSearcher:
    def __init__(self, text: str, corte: str):
        self.openai_client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.text = text

        self.logger = LoggerConfig().setup_logging()
        self.corte = corte
        self.w_client = weaviate.connect_to_wcs(
            cluster_url=os.environ.get("WEAVIATE_URL", ""),
            auth_credentials=weaviate.auth.AuthApiKey(
                os.environ.get("WEAVIATE_APIKEY", "")
            ),
            headers={
                "X-OpenAI-Api-Key": os.environ.get("OPENAI_APIKEY", "")
            }
        )

    def get_similar_sentenze(self) -> list[dict[str, str]]:
        self.logger.info("get_similar_sentenze called22")
        db = self.w_client.collections.get("Sentenze")
        return "OK"