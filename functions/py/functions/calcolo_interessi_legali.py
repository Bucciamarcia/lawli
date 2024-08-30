from openai import OpenAI
import json
from pydantic import BaseModel, ConfigDict
from typing import Literal
from py.constants import CALCOLO_INTERESSI_LEGALI_SYSPROMPT
import os
from py.logger_config import LoggerConfig


class CalcoloInteressiLegali:
    """Returns the parameters for the calculation of legal interest starting from a text document.
    * text: The text to be processed (Strigified document).

    Returns a dictionary:

    {
        "data iniziale": "01/01/2021", -- string
        "data finale": "01/01/2022", -- string
        "capitale": 1000, -- int
        "capitalizzazione": "Annuale", -- string (options: "Annuale", "Semestrale", "Trimestrale", "Nessuna")
    }

    If the document doesn't contain a certain information, the associated value will be an empty string.
    """

    def __init__(self, text: str):
        self.text = text
        self.logger = LoggerConfig().setup_logging(logger_name="CalcoloInteressiLegali")
        self.client = OpenAI(api_key=os.environ.get("OPENAI_APIKEY"))

    def run(self) -> dict[str, str | int]:
        response = self.client.beta.chat.completions.parse(
            model="gpt-4o-2024-08-06",
            messages=[
                {"role": "system", "content": CALCOLO_INTERESSI_LEGALI_SYSPROMPT},
                {"role": "user", "content": self.text},
            ],
            response_format=ResponseFormat,
        )
        answer = response.choices[0].message.content
        self.logger.info(f"answer: {answer}")
        return json.loads(answer if answer else "{}")


class ResponseFormat(BaseModel):
    data_iniziale: str
    data_finale: str
    capitale_iniziale: int
    capitalizzazione: Literal["", "Annuale", "Semestrale", "Trimestrale", "Nessuna"]

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "data_iniziale": "01/01/2021",
                "data_finale": "01/01/2022",
                "capitale_iniziale": 1000,
                "capitalizzazione": "annuale",
            }
        }
    )
