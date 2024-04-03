from py.logger_config import logger
from openai import OpenAI, OpenAIError
import os
from py.constants import *
from py.commons import Cloud_Storege_Util

class General_Summary:
    """
    Classe che si occupa di creare il riassunto generale della pratica.
    Richiede in input i riassunti parziali delle singole parti della pratica.
    """
    def __init__(self, partial_summaries: list[str], pratica_id:str, account_name:str):
        self.partial_summaries = partial_summaries
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.pratica_id = pratica_id
        self.account_name = account_name
    
    def stringify_summaries(self, summaries: list[str]) -> str:
        """
        Concatena i riassunti parziali in un unico testo. FORMATO:
        ## RIASSUNTO 1
        testo riassunto 1
        ## RIASSUNTO 2
        """
        return "\n\n".join([f"## RIASSUNTO {i+1}\n{summary}" for i, summary in enumerate(summaries)])
    
    def create_general_summary(self) -> None:
        """
        Entrypoint: crea il riassunto generale della pratica.
        """
        stringified_summaries = self.stringify_summaries(self.partial_summaries)

        messages = [
            {"role": "system", "content": CREATE_GENERAL_SUMMARY_SYS},
            {"role": "user", "content": stringified_summaries}
        ]

        try:
            response = self.client.chat.completions.create(
                model=BEST_GPT_MODEL,
                messages=messages,
            )
            general_summary = response.choices[0].message.content
        except OpenAIError as e:
            logger.error(f"Errore nella creazione del riassunto generale: {e}")
            raise f"Errore nella creazione del riassunto generale: {e}"
        except Exception as e:
            logger.error(f"Errore sconosciuto nella creazione del riassunto generale: {e}")
            raise f"Errore sconosciuto nella creazione del riassunto generale: {e}"
        
        try:
            Cloud_Storege_Util().write_text_file(f"accounts/{self.account_name}/pratiche/{self.pratica_id}/riassunto generale.txt", general_summary)
        except Exception as e:
            logger.error(f"Errore nella scrittura del riassunto generale: {e}")
            raise f"Errore nella scrittura del riassunto generale: {e}"