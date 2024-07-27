from openai import OpenAI, OpenAIError
from py.logger_config import LoggerConfig
from py.constants import OPENAI_API_KEY, TEMPLATE_ENGINE, TEMPLATE_SYPROMPT


class Template:
    """
    Template or models for documents.
    """

    def __init__(self, title: str, text: str):
        self.title = title
        self.text = text
        self.logger = LoggerConfig().setup_logging()
        self.client = OpenAI(api_key=OPENAI_API_KEY)

    def get_brief_description(self) -> str:
        """Generate a brief description of the template"""
        try:
            response = self.client.chat.completions.create(
                model=TEMPLATE_ENGINE,
                messages=[
                    {"role": "system", "content": TEMPLATE_SYPROMPT},
                    {"role": "user", "content": f"TITOLO: {self.title}\n\nTEMPLATE: {self.text}"},
                ]
            )
            content = response.choices[0].message.content
            return content if content else ""
        except OpenAIError as e:
            self.logger.error(f"OpenAIError: {e}")
            return ""
