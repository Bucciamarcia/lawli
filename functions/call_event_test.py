from py.functions import generate_timeline
import firebase_admin
from py.logger_config import LoggerConfig

logger = LoggerConfig(target="local").setup_logging()

firebase_admin.initialize_app()

logger.info("STARTING")
tester = generate_timeline.TimelineGenerator("lawli", "1")

tester.generate_timeline()