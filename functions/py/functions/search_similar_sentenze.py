from py.logger_config import logger
from openai import OpenAI, OpenAIError
import os


class SentenzeSearcher:
    def __init__(self, text: str, corte: str):
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))
        self.text = text
        self.corte = corte