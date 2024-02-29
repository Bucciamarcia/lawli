"""
Classi e metodi comuni a più funzioni.
"""

from firebase_functions import https_fn

def cors_headers_preflight(req: https_fn.Request) -> https_fn.Response:
    """
    Add CORS headers for preflight requests.
    """
    cors_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Max-Age': '3600',
    }
    return https_fn.Response('', headers=cors_headers)

def cors_headers(response: https_fn.Response) -> https_fn.Response:
    """
    Add CORS headers to the response.
    """
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    return response