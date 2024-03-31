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
CLEAR_TIMELINE_ENGINE = BEST_GPT_MODEL

GENERATE_TIMELINE_FIRST_PROMPT = """L'utente ti passerà un documento relativo a una causa legale. Il tuo compito è quello di scrivere una timeline lunga e dettagliata degli eventi in ordine cronologico in formato JSON.

Segui le seguenti istruzioni:

- Includi solo gli eventi relativi direttamente alla causa in oggetto, non tutti gli eventi menzionati.
- Includi solo eventi la cui data completa è presente.
- Per quanto sintetici, gli eventi devono essere dettagliati e completi di contesto.

ESEMPIO SBAGLIATO:
"2022-01-01": "Contratto firmato"
ESEMPIO CORRETTO:
{
    "data": "2022-01-01",
    "evento": "Contratto firmato tra Azienda X e Lavoratore Y"
}

ESEMPIO SBAGLIATO:
{
    "data": "2022-01-01",
    "evento": "Inviato fax a Azienda X"
}
ESEMPIO CORRETTO:
{
    "data": "2022-01-01",
    "evento": "Inviato fax a Azienda X per richiesta di documenti mancanti"
}
Formatta il JSON come segue:

{
    "timeline": [
        {
            "data": "2022-01-01",
            "evento": "Evento 1"
        },
        {
            "data": "2022-01-02",
            "evento": "Evento 2"
        }
    ]
}"""

GENERATE_TIMELINE_CLEAR_TIMELINE_SYSPROMPT = """L'utente di passerà un json contenente la timeline di un documento legale. Questa timeline potrebbe inlcudere elementi duplicati. Il tuo compito è quello di rimuovere gli elementi duplicati e restituire la timeline pulita.

Segui le seguenti istruzioni:

- Non alterare il contenuto del json in alcun modo: scegli solo se mantenerlo o rimuoverlo (se ridondante); nel caso, mantieni l'evento di maggiore qualità.
- Restituisci il json pulito ordinato dal più recente al più vecchio (ordine crolologico decrescente).

Formatta il JSON come segue:

{
    "timeline": [
        {
            "data": "2022-01-01",
            "evento": "Evento 1"
        },
        {
            "data": "2022-01-02",
            "evento": "Evento 2"
        }
    ]
}"""
TIMELINE_DOCUMENT_PATH = "accounts/{assistito}/pratiche/{pratica}/documenti/{documento}"