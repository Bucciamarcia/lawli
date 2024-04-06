from py.functions import SentenzeSearcher
import firebase_admin
from py.logger_config import LoggerConfig

logger = LoggerConfig(target="local").setup_logging()

firebase_admin.initialize_app()

logger.info("STARTING")
tester = SentenzeSearcher("condominio", "tutti")
print(tester.get_similar_sentenze())
