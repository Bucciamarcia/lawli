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
from py.constants import PROJECT_ID


def initialize_env():
    with open(".env.yaml") as f:
        data = yaml.safe_load(f)

    for key, value in data.items():
        os.environ[key] = value


logger = LoggerConfig().setup_logging()

initialize_app()


@https_fn.on_call(timeout_sec=360)
def get_text_from_pdf(req: https_fn.CallableRequest) -> dict[str, str]:
    initialize_env()

    logger.info("get_text_from_pdf called")

    keys = ["idPratica", "fileName", "fileBytes", "accountName"]

    id_pratica, file_name, file_bytes, account_name = commons.get_data(req, keys)
    project_id = PROJECT_ID
    path = f"gs://{project_id}.appspot.com/accounts/{account_name}/pratiche/{str(id_pratica)}/documenti/originale_{file_name}"

    functions.Pdf_Transformer(path, file_bytes).process_pdf()
    # TODO: Test this function after putting path in here.
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
    keys = ["assistantName", "praticaId", "accountId"]
    (assistant_name, pratica_id, account_id) = commons.get_data(req, keys)
    logger.info(f"ASSISTANT_ID: {assistant_name}")
    result = functions.Create_Assistant(pratica_id, account_id).process_assistant(
        assistant_name
    )
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


@https_fn.on_call(timeout_sec=300)
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


@https_fn.on_call(timeout_sec=180)
def get_template_brief_description(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("get_template_brief_description called")
    keys = ["title", "text"]
    title, text = commons.get_data(req, keys)
    result = functions.Template(title, text).get_brief_description()
    return result


@https_fn.on_call(timeout_sec=180)
def get_template_formatted(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("get_template_formatted called")
    keys = ["title", "text"]
    title, text = commons.get_data(req, keys)
    result = functions.Template(title, text).process_text()
    if result:
        return result
    else:
        raise Exception("Error in processing the template")


@https_fn.on_call()
def add_template_to_weaviate(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("add_template_to_weaviate called")
    keys = ["title", "text", "briefDescription", "tenant"]
    title, text, brief_description, tenant = commons.get_data(req, keys)
    try:
        functions.Template(title, text, brief_description).save_to_weaviate(tenant)
        return "OK"
    except Exception as e:
        logger.error(f"Error in add_template_to_weaviate: {e}")
        raise Exception(f"Error in add_template_to_weaviate: {e}")


@https_fn.on_call()
def search_similar_templates(req: https_fn.CallableRequest) -> list[dict[str, str]]:
    initialize_env()
    logger.info("search_similar_templates called")
    keys = ["query", "account"]
    query, tenant = commons.get_data(req, keys)
    result = functions.TemplateSearcher().search(query, tenant)
    return result


@https_fn.on_call()
def delete_template_from_weaviate(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("delete_template_from_weaviate called")
    keys = ["title", "text", "client"]
    title, text, tenant = commons.get_data(req, keys)
    try:
        functions.Template(title, text).delete_from_weaviate(tenant)
        logger.info("OK!")
        return "OK"
    except Exception as e:
        logger.error(f"Error in delete_template_from_weaviate: {e}")
        raise Exception(f"Error in delete_template_from_weaviate: {e}")


@https_fn.on_call()
def get_likley_templates(req: https_fn.CallableRequest) -> list[dict[str, str]]:
    initialize_env()
    logger.info("get_likley_templates called")
    keys = ["query", "client"]
    query, tenant = commons.get_data(req, keys)
    result = functions.LikleyTemplateFinder().find(query, tenant)
    return result


@https_fn.on_call()
def string_to_docx(req: https_fn.CallableRequest) -> str:
    initialize_env()
    logger.info("string_to_docx called")
    keys = ["text"]
    (text,) = commons.get_data(req, keys)
    return functions.DocxCreator(text).create_docx()


@https_fn.on_call()
def calcolo_interessi_legali_data(
    req: https_fn.CallableRequest,
) -> dict[str, str | int]:
    """Returns the parameters for the calculation of legal interest starting from a text document.
    * text: The text to be processed (Strigified document).

    Returns a dictionary:

    {
        "data iniziale": "01/01/2021", -- string
        "data finale": "01/01/2022", -- string
        "capitale": 1000, -- int
        "capitalizzazione": "annuale", -- string (options: "annuale", "semestrale", "trimestrale", "nessuna")
    }

    If the document doesn't contain a certain information, the associated value will be an empty string.
    """
    initialize_env()
    logger.info("calcolo_interessi_legali_data called")
    keys = ["text"]
    (text,) = commons.get_data(req, keys)
    return functions.CalcoloInteressiLegali(text).run()


@functions_framework.cloud_event  # type: ignore
def get_txt_from_docai_json(event: CloudEvent) -> dict[str, str]:
    logger.info("on_pubsub_message called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    is_docucment = commons.check_is_document(object_id)

    if is_docucment:
        functions.Json_Transformer(decoded, object_id).process_json()
    else:
        logger.info(f"Not a document: {object_id}")

    return {"status": "ok"}


@functions_framework.cloud_event  # type: ignore
def generate_document_summary(event: CloudEvent) -> dict[str, str]:
    logger.info("generate_document_summary called")
    logger.info(event)
    object_id = event.data["message"]["attributes"]["objectId"]
    decoded = base64.b64decode(event.data["message"]["data"]).decode()
    filename = os.path.basename(object_id)
    is_txt = commons.check_ext(filename)
    is_document = commons.check_is_document(object_id)

    if is_txt and is_document:
        functions.Generated_Document(decoded, object_id).process_document()
        functions.Brief_Description(decoded, object_id).process_brief_description()
    else:
        logger.info(f"Not a txt file or not a document: {object_id}")

    return {"status": "ok"}
