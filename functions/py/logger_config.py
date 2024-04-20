import google.cloud.logging
import os
import logging


class LoggerConfig:
    """Set ups logging. Detects if running on GCP or local."""
    def __init__(self):
        pass

    def setup_logging(self):
        if "K_SERVICE" in os.environ:
            client = google.cloud.logging.Client()
            handler = client.get_default_handler()
            client.setup_logging()
            logger = logging.getLogger("cloudLogger")
            logger.setLevel(logging.INFO)
            logger.addHandler(handler)
            formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
                )
            handler.setFormatter(formatter)
        else:
            # Log to console
            logging.basicConfig(level=logging.INFO)
            logger = logging.getLogger("consoleLogger")
            formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
                )
            console = logging.StreamHandler()
            console.setFormatter(formatter)
            logger.addHandler(console)
        return logger
