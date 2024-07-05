from py.logger_config import LoggerConfig
import os
import weaviate
import weaviate.classes as wvc


class SentenzeSearcher:
    def __init__(self, text: str, corte: str):
        self.text = text

        self.logger = LoggerConfig().setup_logging()
        self.corte = corte
        try:
            self.w_client = weaviate.connect_to_wcs(
                cluster_url=os.environ.get("WEAVIATE_URL", ""),
                auth_credentials=weaviate.auth.AuthApiKey(
                    os.environ.get("WEAVIATE_APIKEY", "")
                ),
                headers={
                    "X-OpenAI-Api-Key": os.environ.get("OPENAI_APIKEY", "")
                }
            )
        except Exception as e:
            self.logger.error(f"Generic error connecting to Weaviate: {e}")
            raise Exception(f"Generic error connecting to Weaviate: {e}")
        self.db = self.w_client.collections.get("Sentenze")
        self.limit = 10

    def search_generic(self):
        self.logger.info("search_generic called")
        response = self.db.query.near_text(
            query=self.text,
            limit=self.limit,
            return_metadata=wvc.query.MetadataQuery(distance=True)
        )
        return response

    def search_by_corte(self):
        self.logger.info("search_by_corte called")
        response = self.db.query.near_text(
            query=self.text,
            limit=self.limit,
            return_metadata=wvc.query.MetadataQuery(distance=True),
            filters=wvc.query.Filter.by_property("corte").equal(self.corte)
        )
        return response

    def get_similar_sentenze(self) -> list[dict[str, str | float | None]]:
        self.logger.info("get_similar_sentenze called")
        if self.corte == "tutte":
            response = self.search_generic()
        else:
            response = self.search_by_corte()

        results = []
        for o in response.objects:
            properties = o.properties
            results.append({
                "titolo": properties["titolo"],
                "contenuto": properties["contenuto"],
                "corte": properties["corte"],
                "distance": o.metadata.distance
            })
        return results
