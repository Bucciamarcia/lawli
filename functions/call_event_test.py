from py.functions import TimelineGenerator
import firebase_admin

firebase_admin.initialize_app()

tester = TimelineGenerator(account_name="lawli", pratica_id="6")
tester.generate_timeline()
