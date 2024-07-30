from py.logger_config import LoggerConfig
from py.weaviate_operations import WeaviateOperations


class LikleyTemplateFinder:
    def __init__(self):
        self.logger = LoggerConfig().setup_logging()

    def find(self, query: str, tenant: str) -> list[dict[str, str]]:
        self.logger.info("get_likley_templates called")
        with WeaviateOperations(collection="Template") as w:
            objects = w.near_text(query=query, tenant=tenant, limit=10)
        results = []
        for o in objects:
            properties = o.properties
            results.append(
                {
                    "title": properties["title"],
                    "text": properties["text"],
                    "briefDescription": properties["brief_description"],
                }
            )
            self.logger.info(f"Found similar template: {properties['title']}")
        self.logger.info(f"Found {len(results)} similar templates:\n\n{results}")
        return results
