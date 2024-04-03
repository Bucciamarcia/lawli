import google.cloud.logging
import logging

class LoggerConfig:
    """Set ups logging. Defauls to cloud logging, but if target is set to "local" it will log to the console."""
    def __init__(self, target:str = "cloud"):
        self.target = target

    def setup_logging(self):
        if self.target == "cloud":
            client = google.cloud.logging.Client()
            handler = client.get_default_handler()
            client.setup_logging()
            logger = logging.getLogger("cloudLogger")
            logger.setLevel(logging.INFO)
            logger.addHandler(handler)
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            handler.setFormatter(formatter)
        else:
            # Log to console
            logging.basicConfig(level=logging.INFO)
            logger = logging.getLogger("consoleLogger")
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            console = logging.StreamHandler()
            console.setFormatter(formatter)
            logger.addHandler(console)
        return logger

logger = LoggerConfig().setup_logging()