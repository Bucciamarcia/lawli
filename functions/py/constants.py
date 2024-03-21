# GENERIC

SUCCESS_RESPONSE = {"status": 200, "response": "Success"}

PROJECT_ID = "lawli-bab83"

BEST_GPT_MODEL = "gpt-4-1106-preview"

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