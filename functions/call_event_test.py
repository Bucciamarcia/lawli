from py.functions import SentenzeSearcher
import firebase_admin
import json

firebase_admin.initialize_app()

tester = SentenzeSearcher("condominio", "tutte")
print(tester.get_similar_sentenze())
with open("test.json", "w", encoding="utf-8") as f:
    f.write(json.dumps(
        tester.get_similar_sentenze(), indent=4, ensure_ascii=False
    ))
