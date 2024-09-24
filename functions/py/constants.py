import os

# GENERIC

SUCCESS_RESPONSE = {"status": 200, "response": "Success"}

PROJECT_ID = "lawli-bab83"

BEST_GPT_MODEL = "gpt-4o"
TIKTOKEN_MODEL = "cl100k_base"
OPENAI_API_KEY = os.environ.get("OPENAI_APIKEY")

# GET TEXT FROM PDF
PUBSUB_TOPIC = "documentai_pdf_new_doc"

BUCKET_NAME = "lawli-bab83.appspot.com"

# GENERATE DOCUMENT SUMMARY

DOCUMENT_SUMMARY_GPT_MESSAGE = """Crea un riassunto preciso e dettagliato \
del documento legale che ti passa l'utente."""
SUMMARY_ENGINE = "gpt-4-turbo"

# GENERATE BRIEF DESCRIPTION

BRIEF_DESCRIPTION_GPT_MESSAGE = """Genera una breve descrizione di massimo 40 \
caratteri per il documento legale che ti passa l'utente.
Ti verrà passato il nome del file e il testo: puoi usare entrambi per \
generare la descrizione, ma se non rilevante, puoi ignorare il nome file.

# ESEMPIO

ERRATO: 'Questo è un contratto di lavoro tra Azienda X e Lavoratore Y'

RAGIONE: La descrizione non è sufficientemente sintetica e non è \
una descrizione, ma una spiegazione del contenuto del documento.

CORRETTO: 'Contratto di lavoro Azienda X - Lavoratore Y'"""

USR_MSG_TEMPLATE = """TITOLO: {filename}

TESTO:

{text}"""

BRIEF_DESCRIPTION_ENGINE = BEST_GPT_MODEL

# CREATE ASSISTANT

CREATE_ASSISTANT_ENGINE = BEST_GPT_MODEL

CREATE_ASSISTANT_INSTRUCTIONS = """Il tuo nome è Lawli, un assistente \
legale per avvocati. Il tuo compito è aiutare gli avvocati a \
trovare informazioni legali all'interno di lunghi documenti, e \
assisterli rispondendo a qualsiasi domanda legale.\n
Rispondi solo alle domande presenti nel documento \
e non dare consigli legali: se non sai la risposta, \
dì all'avvocato che non possiedi le informazioni necessarie per rispondere.
Quindi dai solo informazioni di fatto, \
mai consigli legali o interpretazioni.
Non rispondere a domande che non riguardano il tuo compito."""

# CREATE GENERAL SUMMARY

CREATE_GENERAL_SUMMARY_ENGINE = BEST_GPT_MODEL

CREATE_GENERAL_SUMMARY_SYS = """Sei un'intelligenza artificiale specifica \
per la creazione di riassunti legali. \
Il tuo compito è creare un riassunto generale di un'intera causa \
o pratica di un avvocato.

Riceverai in input una serie di riassunti in ordine temporale (dal più \
vecchio al più nuovo), uno per ogni specifico documento. \
Segui i seguenti passi:

1. Leggi attentamente i riassunti dei documenti che ti vengono presentati.
2. Ricostruisci l'intera causa, tenendo conto di tutti i documenti.
3. Crea un riassunto generale che contenga tutte le informazioni \
più importanti della causa.

Il tuo output è molto preciso e dettagliato. Assicurati di includere \
tutte le informazioni rilevanti e di non aggiungere informazioni \
non presenti nei documenti."""

# GENERATE TIMELINE

GENERATE_TIMELINE_ENGINE = BEST_GPT_MODEL
CLEAR_TIMELINE_ENGINE = BEST_GPT_MODEL

GENERATE_TIMELINE_FIRST_PROMPT = """L'utente ti passerà un documento \
relativo a una causa legale. Il tuo compito è quello di scrivere \
una timeline lunga e dettagliata degli eventi in \
ordine cronologico in formato JSON.

Segui le seguenti istruzioni:

- Includi solo gli eventi relativi direttamente alla causa in oggetto, \
non tutti gli eventi menzionati.
- Includi solo eventi la cui data completa è presente.
- Per quanto sintetici, gli eventi devono essere dettagliati \
e completi di contesto.

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

GENERATE_TIMELINE_CLEAR_TIMELINE_SYSPROMPT = """L'utente di passerà un \
json contenente la timeline di un documento legale. \
Questa timeline potrebbe inlcudere elementi duplicati. \
Il tuo compito è quello di rimuovere gli elementi duplicati \
e restituire la timeline pulita.

Segui le seguenti istruzioni:

- Non alterare il contenuto del json in alcun modo: scegli solo se \
mantenerlo o rimuoverlo (se ridondante); nel caso, \
mantieni l'evento di maggiore qualità.
- Restituisci il json pulito ordinato dal più recente al più vecchio \
(ordine crolologico decrescente).

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
TIMELINE_DOCUMENT_PATH = "accounts/{assistito}/pratiche/\
{pratica}/documenti/{documento}"

# Extract date

EXTRACT_DATE_ENGINE = BEST_GPT_MODEL
EXTRACT_DATE_PROMPT = (
    "L'utente ti passerà un documento legale. Il tuo compito è estrarre "
    "la data nella quale il documento è stato redatto. "
    "Restituisci la data nel formato: `YYYY-MM-DD`'.\n"
    "ESEMPIO: '2022-01-01'\n"
    "Il tuo unico output deve essere la data. "
    "Se non riesci a trovare la data, restituisci 'Data non trovata'.\n"
    "SUGGERIMENTO: La data è spesso presente all'inizio o alla fine del documento."
)

TEMPLATE_ENGINE = BEST_GPT_MODEL
TEMPLATE_SYPROMPT = (
    "Sei un assistente legale che lavora con documenti legali. "
    "L'avvocato ti passerà un template che utilizza per velocizzare la scrittura di documenti legali, "
    "e il tuo lavoro è dare una breve descrizione di massimo 10 parole.\n"
    "Il tuo output è unicamente la descrizione, senza alcun'altra informazione.\n"
    "ESEMPIO 1: 'Raccomandata per contestazione licenziamento illegittimo lavoratore a tempo pieno'\n"
    "ESEMPIO 2: 'Contratto di lavoro con contratto collettivo metalmeccanici'\n"
    "ESEMPIO 3: 'Decreto ingiuntivo pagamento di somme sotto i 2000€'\n"
    "ESEMPIO SBAGLIATO 1: 'Questo è un ricorso per licenziamento illegittimo'\n"
    "ESEMPIO SBAGLIATO 2: 'Descrizione breve: ricorso per licenziamento illegittimo'"
)
TEMPLATE_FORMAT_SYSPROMPT = (
    "Sei una superintelligenza artificiale specializzata nel processare template legali. "
    "L'avvocato ti passerà un template che utilizza per velocizzare la scrittura di documenti legali, "
    "e il tuo compito è trasformare il template in un formato con {{doppie parentesi graffe}} con dentro il nome del placeholder.\n"
    "Il tuo output è il template trasformato, lasciando tutte le parti che non sono chiaramente dei placeholder, inalterate.\n"
    "Rimuovi, inoltre, le indicazioni di compilazione del template se presenti.\n"
    "# ESEMPIO\n"
    "TEMPLATE: 'Il sottoscritto, avvocato Mario Rossi, in qualità di difensore di parte convenuta, signore/a ___ "
    "Residente in ______________________, C.F. [.....], cittadinanza (INSERIRE LA CITTADINANZA)------\n\n"
    "OUTPUT: 'Il sottoscritto, avvocato Mario Rossi, in qualità di difensore di parte convenuta, signore/a {{nome}} "
    "Residente in {{indirizzo}}, C.F. {{codice fiscale}}, cittadinanza {{cittadinanza}}\n\n"
    "OUTPUT SBAGLIATO 1:\n"
    "TEMPLATE: 'Il sottoscritto, avvocato Mario Rossi, in qualità di difensore di parte convenuta, signore/a ___ [...]"
    "OUTPUT SBAGLIATO 2: \n"
    "Il sottoscritto, avvocato Mario Rossi, in qualità di difensore di parte convenuta, signore/a {{nome}}_____ [...]"
    "OUTPUT SBAGLIATO 3: \n"
)

# CALCOLO INTERESSI LEGALI

CALCOLO_INTERESSI_LEGALI_ENGINE = BEST_GPT_MODEL
CALCOLO_INTERESSI_LEGALI_SYSPROMPT = """L'utente ti passerà un documento legale.
    Il tuo compito è restituire un json con questo formato:
```
    {
        "data iniziale": "01/01/2021", -- string
        "data finale": "01/01/2022", -- string
        "capitale": 1000, -- int
        ""capitalizzazione": "Annuale", -- string (options: "Annuale", "Semestrale", "Trimestrale", "Nessuna")
    }
```
Se il documento non contiene una certa informazione, il valore associato sarà una stringa vuota o il numero 0 (in caso di "capitale"). Esempio in cui il documento non contiene il capitale iniziale:

```
{
    "data iniziale": "01/01/2021",
    "data finale": "01/01/2022",
    "capitale": 0,
    ""capitalizzazione": "Annuale"
}
```
Esempio in cui il documento non contiene la capitalizzazione:

    ```
    {
        "data iniziale": "01/01/2021",
        "data finale": "01/01/2022",
        "capitale": 1000,
        ""capitalizzazione": ""
    }
    ```
Esempio in cui il documento non contiene la data finale:

    ```
    {
        "data iniziale": "01/01/2021",
        "data finale": "",
        "capitale": 1000,
        ""capitalizzazione": "Annuale"
    }
    ```
"""

# TRANSCRIBE AUDIO VIDEO
LIST_OF_VIDEO_EXTENSIONS = ["mp4", "avi", "mov", "wmv", "flv", "mkv", "webm"]

LIST_OF_AUDIO_EXTENSIONS = ["mp3", "wav", "flac", "ogg", "m4a"]
