import base64
from py.functions.generate_brief_description import Brief_Description as test
import logging
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("cloudLogger")

data = {'attributes': {'specversion': '1.0', 'id': '10418148017162937', 'source': '//pubsub.googleapis.com/projects/lawli-bab83/topics/generate_document_summary', 'type': 'google.cloud.pubsub.topic.v1.messagePublished', 'datacontenttype': 'application/json', 'time': '2024-03-09T13:12:30.769Z'}, 'data': {'message': {'attributes': {'bucketId': 'lawli-bab83.appspot.com', 'eventTime': '2024-03-09T13:12:30.521341Z', 'eventType': 'OBJECT_FINALIZE', 'notificationConfig': 'projects/_/buckets/lawli-bab83.appspot.com/notificationConfigs/14', 'objectGeneration': '1709989950510946', 'objectId': 'accounts/lawli/pratiche/1/documenti/originale_agrieuro.txt', 'overwroteGeneration': '1709551278562825', 'payloadFormat': 'JSON_API_V1'}, 'data': 'ewogICJraW5kIjogInN0b3JhZ2Ujb2JqZWN0IiwKICAiaWQiOiAibGF3bGktYmFiODMuYXBwc3BvdC5jb20vYWNjb3VudHMvbGF3bGkvcHJhdGljaGUvMS9kb2N1bWVudGkvb3JpZ2luYWxlX2FncmlldXJvLnR4dC8xNzA5OTg5OTUwNTEwOTQ2IiwKICAic2VsZkxpbmsiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vc3RvcmFnZS92MS9iL2xhd2xpLWJhYjgzLmFwcHNwb3QuY29tL28vYWNjb3VudHMlMkZsYXdsaSUyRnByYXRpY2hlJTJGMSUyRmRvY3VtZW50aSUyRm9yaWdpbmFsZV9hZ3JpZXVyby50eHQiLAogICJuYW1lIjogImFjY291bnRzL2xhd2xpL3ByYXRpY2hlLzEvZG9jdW1lbnRpL29yaWdpbmFsZV9hZ3JpZXVyby50eHQiLAogICJidWNrZXQiOiAibGF3bGktYmFiODMuYXBwc3BvdC5jb20iLAogICJnZW5lcmF0aW9uIjogIjE3MDk5ODk5NTA1MTA5NDYiLAogICJtZXRhZ2VuZXJhdGlvbiI6ICIxIiwKICAiY29udGVudFR5cGUiOiAidGV4dC9wbGFpbjsgY2hhcnNldD11dGYtOCIsCiAgInRpbWVDcmVhdGVkIjogIjIwMjQtMDMtMDlUMTM6MTI6MzAuNTIxWiIsCiAgInVwZGF0ZWQiOiAiMjAyNC0wMy0wOVQxMzoxMjozMC41MjFaIiwKICAic3RvcmFnZUNsYXNzIjogIlNUQU5EQVJEIiwKICAidGltZVN0b3JhZ2VDbGFzc1VwZGF0ZWQiOiAiMjAyNC0wMy0wOVQxMzoxMjozMC41MjFaIiwKICAic2l6ZSI6ICI0NCIsCiAgIm1kNUhhc2giOiAiYTZQSzdodVFyRkUybk1CaW1BeTBhdz09IiwKICAibWVkaWFMaW5rIjogImh0dHBzOi8vc3RvcmFnZS5nb29nbGVhcGlzLmNvbS9kb3dubG9hZC9zdG9yYWdlL3YxL2IvbGF3bGktYmFiODMuYXBwc3BvdC5jb20vby9hY2NvdW50cyUyRmxhd2xpJTJGcHJhdGljaGUlMkYxJTJGZG9jdW1lbnRpJTJGb3JpZ2luYWxlX2FncmlldXJvLnR4dD9nZW5lcmF0aW9uPTE3MDk5ODk5NTA1MTA5NDYmYWx0PW1lZGlhIiwKICAiY29udGVudERpc3Bvc2l0aW9uIjogImlubGluZTsgZmlsZW5hbWUqPXV0Zi04JydvcmlnaW5hbGVfYWdyaWV1cm8udHh0IiwKICAibWV0YWRhdGEiOiB7CiAgICAiZmlyZWJhc2VTdG9yYWdlRG93bmxvYWRUb2tlbnMiOiAiYWQ4NjIxYWUtMjIyNC00YTkxLWJkM2EtYjQ2YmEzZTI1NjFkIgogIH0sCiAgImNyYzMyYyI6ICJlZENGenc9PSIsCiAgImV0YWciOiAiQ09LdXgveWc1NFFERUFFPSIKfQo=', 'messageId': '10418148017162937', 'message_id': '10418148017162937', 'publishTime': '2024-03-09T13:12:30.769Z', 'publish_time': '2024-03-09T13:12:30.769Z'}, 'subscription': 'projects/lawli-bab83/subscriptions/eventarc-europe-west3-generate-document-summary-641344-sub-230'}}

decoded = base64.b64decode(data['data']['message']['data']).decode()
object_id = data["data"]["message"]["attributes"]["objectId"]

result = test(logger, decoded, object_id).process_brief_description()

print(result)