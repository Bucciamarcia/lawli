import google.cloud.logging
import os
import logging


class LoggerConfig:
    """Set up logging. Detects if running on GCP or local."""
    def __init__(self):
        pass

    def setup_logging(self):
        logger_name = "cloudLogger" if "K_SERVICE" in os.environ else "consoleLogger"
        logger = logging.getLogger(logger_name)

        if not logger.handlers:
            if "K_SERVICE" in os.environ:
                client = google.cloud.logging.Client()
                handler = client.get_default_handler()
                client.setup_logging()
                logger.setLevel(logging.INFO)
                formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
                handler.setFormatter(formatter)
                logger.addHandler(handler)  # Make sure to add the handler here
            else:
                # Log to console
                console = logging.StreamHandler()
                formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
                console.setFormatter(formatter)
                logger.addHandler(console)
                logger.setLevel(logging.INFO)

        return logger
