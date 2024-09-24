from openai import OpenAI
import os
from py.logger_config import LoggerConfig
from py.constants import BEST_GPT_MODEL


class TrascrizioneSummaries:
    def __init__(self, trascrizione: str):
        self.trascrizione = trascrizione
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.logger = LoggerConfig().setup_logging()

    def get_long_summary(self) -> str | None:
        response = self.client.chat.completions.create(
            model=BEST_GPT_MODEL,
            messages=[
                {
                    "role": "system",
                    "content": "Sei un'intelligenza artificiale per uso legale. Scrivi un riassunto completo, dettagliato ed estensivo della trascrizione fornita dall'utente. Il tuo output è unicamente il riassuto della trascrizione. È vietato interagire con l'utente: non fare domande, non chiedere informazioni aggiuntive, non rispondere a domande, non parlare direttamente a lui. Se non puoi generare un riassunto per qualsiasi ragione, il tuo output è 'Impossibile generare il riassunto: [ragione]'.",
                },
                {"role": "user", "content": self.trascrizione},
            ],
        )
        return response.choices[0].message.content

    def get_short_summary(self) -> str | None:
        response = self.client.chat.completions.create(
            model=BEST_GPT_MODEL,
            messages=[
                {
                    "role": "system",
                    "content": "Sei un'intelligenza artificiale per uso legale. Scrivi un riassunto breve, conciso e chiaro della trascrizione fornita dall'utente. Il tuo output è unicamente il riassunto della trascrizione. È vietato interagire con l'utente: non fare domande, non chiedere informazioni aggiuntive, non rispondere a domande, non parlare direttamente a lui. Se non puoi generare un riassunto per qualsiasi ragione, il tuo output è 'Impossibile generare il riassunto: [ragione]'.",
                },
                {"role": "user", "content": self.trascrizione},
            ],
        )
        return response.choices[0].message.content
