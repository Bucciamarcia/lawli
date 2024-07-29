from py.weaviate_operations import WeaviateOperations
from py.logger_config import LoggerConfig


class TemplateSearcher:
    def __init__(self):
        self.logger = LoggerConfig().setup_logging()

    def search(self, query, tenant) -> list[dict[str, str]]:
        self.logger.info("search_similar_templates called")
        with WeaviateOperations(collection="Template") as w:
            objects = w.near_text(query=query, tenant=tenant)
        results = []
        for o in objects:
            properties = o.properties
            results.append(
                {
                    "title": properties["title"],
                    "text": properties["text"],
                    "brief_description": properties["brief_description"],
                }
            )
            self.logger.info(f"Found similar template: {properties['title']}")
        self.logger.info(f"Found {len(results)} similar templates:\n\n{results}")
        return results
