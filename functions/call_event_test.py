from py.functions import TemplateSearcher
import firebase_admin

firebase_admin.initialize_app()

tester = TemplateSearcher()
tester.search("pignoramento", "lawli")
