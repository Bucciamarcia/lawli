from py.functions import Create_Assistant
import firebase_admin

firebase_admin.initialize_app()

tester = Create_Assistant()
print(tester.process_assistant("2 fasc di I grado 6 memoria 183 n 1.pdf"))
