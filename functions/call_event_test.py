from py.functions import SentenzeSearcher
import firebase_admin


firebase_admin.initialize_app()

tester = SentenzeSearcher("condominio", "tutti")
print(tester.get_similar_sentenze())
