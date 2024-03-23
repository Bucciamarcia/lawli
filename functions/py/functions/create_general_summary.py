from py.logger_config import logger
import datetime

class General_Summary:
    """
    Classe che si occupa di creare il riassunto generale della pratica.
    Richiede solo id pratica e account name, e si occupa di pescare i documenti dal db e ordinarli.
    """
    def __init__(self, id_pratica:int, account_name:str):
        self.id_pratica = id_pratica
        self.account_name = account_name
    
    def create_general_summary(self):
        """
        Entrypoint: crea il riassunto generale della pratica.
        """

class Documento:
    """
    Classe che definisce la struttura di Documento e i metodi per la sua manipolazione.
    """
    def __init__(self, filename:str, data:datetime.date, summary:str):
        self.filename = filename
        self.data = data
        self.summary = summary