import google.cloud.logging
import logging

client = google.cloud.logging.Client()
handler = client.get_default_handler()
client.setup_logging()
logger = logging.getLogger("cloudLogger")
logger.setLevel(logging.INFO)
logger.addHandler(handler)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)