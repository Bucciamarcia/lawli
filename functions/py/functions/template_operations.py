import time
from openai import OpenAI, OpenAIError
from py.weaviate_operations import WeaviateOperations
from weaviate.classes.query import Filter
from py.logger_config import LoggerConfig
from py.constants import (
    OPENAI_API_KEY,
    TEMPLATE_ENGINE,
    TEMPLATE_SYPROMPT,
    TEMPLATE_FORMAT_SYSPROMPT,
)


class Template:
    """
    Template or models for documents.
    """

    def __init__(self, title: str, text: str, brief_description: str | None = None):
        self.title = title
        self.text = text
        self.brief_description = brief_description
        self.logger = LoggerConfig().setup_logging()
        self.client = OpenAI(api_key=OPENAI_API_KEY)

    def get_brief_description(self) -> str:
        """Generate a brief description of the template"""
        try:
            response = self.client.chat.completions.create(
                model=TEMPLATE_ENGINE,
                messages=[
                    {"role": "system", "content": TEMPLATE_SYPROMPT},
                    {
                        "role": "user",
                        "content": f"TITOLO: {self.title}\n\nTEMPLATE: {self.text}",
                    },
                ],
            )
            content = response.choices[0].message.content
            return content if content else ""
        except OpenAIError as e:
            self.logger.error(f"OpenAIError: {e}")
            return ""

    def process_text(self) -> str | None:
        """Transforms the template into the format with {{double curly braces}}"""
        try:
            response = self.client.chat.completions.create(
                model=TEMPLATE_ENGINE,
                messages=[
                    {"role": "system", "content": TEMPLATE_FORMAT_SYSPROMPT},
                    {"role": "user", "content": self.text},
                ],
            )
            content = response.choices[0].message.content
            return content
        except OpenAIError as e:
            self.logger.error(f"OpenAIError: {e}")
            return None

    def save_to_weaviate(self, tenant: str):
        """Save the template to Weaviate."""
        self.logger.info("Saving template to Weaviate")
        dict_template = self.to_dict(self)
        with WeaviateOperations(collection="Template") as w_client:
            try:
                w_client.single_import(dict_template, tenant)
            except Exception as e:
                self.logger.error(f"Error in saving to Weaviate: {e}")

    @classmethod
    def to_dict(cls, template: "Template") -> dict:
        """Convert the template to a dictionary."""
        return {
            "title": template.title,
            "text": template.text,
            "brief_description": template.brief_description,
        }

    def delete_from_weaviate(self, tenant: str):
        self.logger.info("Deleting template from Weaviate")
        with WeaviateOperations() as w:
            tries = 0
            while tries < 3:
                try:
                    client = w.start()
                    collection = client.collections.get("Template")
                    collection = collection.with_tenant(tenant)
                    collection.data.delete_many(
                        where=Filter.by_property("title").like(self.title),
                    )
                    self.logger.info("Successfully deleted from Weaviate")
                    break
                except Exception as e:  # Replace SpecificException with the actual exception(s) you expect
                    self.logger.error(f"Error in deleting from Weaviate: {e}")
                    tries += 1
                    if tries < 3:
                        self.logger.info(f"Retrying... (attempt {tries + 1})")
                        time.sleep(2)  # Add a delay before retrying
            else:
                self.logger.error("Failed to delete from Weaviate after 3 attempts")
                raise Exception("Error in deleting from Weaviate")
