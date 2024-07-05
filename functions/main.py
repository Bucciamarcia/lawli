# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from cloudevents.http import CloudEvent
import os
from firebase_admin import initialize_app
from py import functions
import json
from py import commons
import functions_framework
import base64
from py.logger_config import LoggerConfig
import yaml


def initialize_env():
    with open(".env.yaml") as f:
        data = yaml.safe_load(f)

    for key, value in data.items():
        os.environ[key] = value


logger = LoggerConfig().setup_logging()

initialize_app()


@https_fn.on_call(timeout_sec=240)
def get_text_from_pdf(req: https_fn.CallableRequest) -> dict[str, str]:
    initialize_env()

    logger.info("get_text_from_pdf called")

    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, keys)

    functions.Pdf_Transformer(
        id_pratica, file_name, file_bytes, account_name
    ).process_pdf()
    logger.info("OK!")

    return {"status": "ok"}


@https_fn.on_call()
def does_assistant_exist(req: https_fn.CallableRequest) -> bool:
    initialize_env()
    logger.info("does_assistant_exist called")
    keys = ["assistantName"]
    (assistant_name,) = commons.get_data(req, keys)
    result = functions.Does_Assistant_Exist().process_assistant(assistant_name)
    return result


@https_fn.on_call()
def create_assistant(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("create_assistant called")
    keys = ["assistantName"]
    (assistant_name,) = commons.get_data(req, keys)
    logger.info(f"ASSISTANT_ID: {assistant_name}")
    result = functions.Create_Assistant().process_assistant(assistant_name)
    return result


@https_fn.on_call()
def create_thread(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("create_thread called")
    return functions.Create_Thread().create_thread()


@https_fn.on_call(timeout_sec=180)
def interrogate_chatbot(req: https_fn.CallableRequest) -> list[str]:
    initialize_env()
    logger.info("interrogate_chatbot called")
    logger.info(f"REQUEST: {req}")
    keys = ["assistantName", "assistantId", "message", "threadId"]
    assistant_name, assistant_id, message, thread_id = commons.get_data(req, keys)
    return functions.Interrogate_Chatbot().process_interrogation(
        assistant_name, assistant_id, message, thread_id
    )


@https_fn.on_call(timeout_sec=180)
def create_general_summary(req: https_fn.CallableRequest) -> dict[str, str]:
    initialize_env()
    logger.info("create_general_summary called")
    keys = ["partialSummarties", "praticaId", "accountName"]
    partial_summaries, pratica_id, account_name = commons.get_data(req, keys)
    functions.General_Summary(
        partial_summaries, pratica_id, account_name
    ).create_general_summary()
    return {"status": "ok"}


@https_fn.on_call(timeout_sec=180)
def generate_timeline(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("generate_timeline called")
    keys = ["accountName", "praticaId"]
    account_name, pratica_id = commons.get_data(req, keys)
    result = functions.TimelineGenerator(account_name, pratica_id).generate_timeline()
    return result


@https_fn.on_call()
def get_similar_sentences(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("get_similar_sentences called")
    keys = ["text", "corte"]
    text, corte = commons.get_data(req, keys)
    result = functions.SentenzeSearcher(text, corte).get_similar_sentenze()
    return json.dumps(result, ensure_ascii=False)


@https_fn.on_call()
def count_tokens(req: https_fn.CallableRequest) -> int:
    initialize_env()
    logger.info("count_tokens called")
    keys = ["text"]
    (text,) = commons.get_data(req, keys)
    result = functions.Tokenizer.count_tokens(text)
    return result


@https_fn.on_call()
def extract_date(req: https_fn.CallableRequest) -> str:
    """Extension should be passed without the dot."""
    initialize_env()
    logger.info("extract_date called")
    keys = ["accountName", "praticaId", "documentName", "extension"]
    account_name, pratica_id, document_name, extension = commons.get_data(req, keys)
    result = functions.ExtractDate(
        account_name, pratica_id, document_name, extension
    ).extract_date()
    return result


@functions_framework.cloud_event  # type: ignore
def get_txt_from_docai_json(event: CloudEvent) -> dict[str, str]:
    logger.info("on_pubsub_message called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()

    functions.Json_Transformer(decoded, object_id).process_json()

    return {"status": "ok"}


@functions_framework.cloud_event  # type: ignore
def generate_document_summary(event: CloudEvent) -> dict[str, str]:
    logger.info("generate_document_summary called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    filename = os.path.basename(object_id)
    is_txt = commons.check_ext(filename)

    if is_txt:
        functions.Generated_Document(decoded, object_id).process_document()
        functions.Brief_Description(decoded, object_id).process_brief_description()

    return {"status": "ok"}
