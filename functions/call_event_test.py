from py.functions import Create_Assistant
import firebase_admin

firebase_admin.initialize_app()

tester = Create_Assistant()
print(tester.process_assistant("1 sentenza 190-2020 notificata il 4-3-20.pdf"))
