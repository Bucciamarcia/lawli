import os

# GENERIC

SUCCESS_RESPONSE = {"status": 200, "response": "Success"}

PROJECT_ID = "lawli-bab83"

BEST_GPT_MODEL = "gpt-4-1106-preview"
OPENAI_API_KEY = os.environ.get("OPENAI_APIKEY")

# GET TEXT FROM PDF
PUBSUB_TOPIC = "documentai_pdf_new_doc"

BUCKET_NAME = "lawli-bab83.appspot.com"

# GENERATE DOCUMENT SUMMARY

DOCUMENT_SUMMARY_GPT_MESSAGE = """Crea un riassunto preciso e dettagliato del documento legale che ti passa l'utente."""
SUMMARY_ENGINE = "gpt-4-1106-preview"

# GENERATE BRIEF DESCRIPTION

BRIEF_DESCRIPTION_GPT_MESSAGE = """Genera una breve descrizione di massimo 40 caratteri per il documento legale che ti passa l'utente.
Ti verrà passato il nome del file e il testo: puoi usare entrambi per generare la descrizione, ma se non rilevante, puoi ignorare il nome file.

# ESEMPIO

ERRATO: 'Questo è un contratto di lavoro tra Azienda X e Lavoratore Y'

RAGIONE: La descrizione non è sufficientemente sintetica e non è una descrizione, ma una spiegazione del contenuto del documento.

CORRETTO: 'Contratto di lavoro Azienda X - Lavoratore Y'"""

USR_MSG_TEMPLATE = """TITOLO: {filename}

TESTO:

{text}"""

BRIEF_DESCRIPTION_ENGINE = BEST_GPT_MODEL

# CREATE ASSISTANT

CREATE_ASSISTANT_ENGINE = BEST_GPT_MODEL

CREATE_ASSISTANT_INSTRUCTIONS = """Il tuo nome è Lawli, un assistente legale per avvocati. Il tuo compito è aiutare gli avvocati a trovare informazioni legali all'interno di lunghi documenti, e assisterli rispondendo a qualsiasi domanda legale.\nRispondi solo alle domande presenti nel documento e non dare consigli legali: se non sai la risposta, dì all'avvocato che non possiedi le informazioni necessarie per rispondere.\nQuindi dai solo informazioni di fatto, mai consigli legali o interpretazioni.\nNon rispondere a domande che non riguardano il tuo compito."""

# CREATE GENERAL SUMMARY

CREATE_GENERAL_SUMMARY_ENGINE = BEST_GPT_MODEL

CREATE_GENERAL_SUMMARY_SYS = """Sei un'intelligenza artificiale specifica per la creazione di riassunti legali. Il tuo compito è creare un riassunto generale di un'intera causa o pratica di un avvocato.

Riceverai in input una serie di riassunti in ordine temporale (dal più vecchio al più nuovo), uno per ogni specifico documento. Segui i seguenti passi:

1. Leggi attentamente i riassunti dei documenti che ti vengono presentati.
2. Ricostruisci l'intera causa, tenendo conto di tutti i documenti.
3. Crea un riassunto generale che contenga tutte le informazioni più importanti della causa.

Il tuo output è molto preciso e dettagliato. Assicurati di includere tutte le informazioni rilevanti e di non aggiungere informazioni non presenti nei documenti."""

# GENERATE TIMELINE

GENERATE_TIMELINE_ENGINE = BEST_GPT_MODEL

GENERATE_TIMELINE_FIRST_PROMPT = """L'utente ti passerà un documento relativo a una causa legale. Il tuo compito è quello di scrivere una timeline degli eventi in ordine cronologico in formato JSON.\n
Includi solo gli eventi relativi direttamente alla causa in oggetto, non tutti gli eventi menzionati.\n
Includi solo eventi la cui data completa è presente.\n
Formatta il JSON come segue:\n
{\n
    "timeline": [\n
        {\n
            "date": "2021-01-01",\n
            "event": "Evento 1"\n
        },\n
        {\n
            "date": "2021-01-02",\n
            "event": "Evento 2"\n
        }\n
    ]\n
}"""

GENERATE_TIMELINE_CONTINUATION_PROMPT = """
# CONTESTO\n
Questo è la timeline parziale in formato JSON di una causa legale:\n\n

{timeline}\n\n

# ISTRUZIONI\n
Aggiorna la timeline con gli eventi presenti nel documento che ti verrà passato.\n
Includi solo gli eventi relativamente direttamente alla causa in oggetto, non tutti gli eventi menzionati.\n
Includi solo eventi la cui data completa è presente.\n
Il tuo output è un JSON include tutti gli eventi della timeline originale, più gli eventi del documento.\n
Se nel documento del cliente non sono presenti eventi rilevanti, riscrivi il JSON originale."""
TIMELINE_DOCUMENT_PATH = "accounts/{assistito}/pratiche/{pratica}/documenti/{documento}"