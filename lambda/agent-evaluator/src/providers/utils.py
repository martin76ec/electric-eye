import json

def json_safeload(s: str):
    obj = json.loads(s)
    if type(obj) is str:
        obj = json.loads(obj)

    return obj
