#! /usr/bin/env python3
# utf-8

import json
import sys

def toInt(s):
    try:
        return int(s)
    except Exception as e:
        return s

def print_request(item):
        request = item["request"]
        if isinstance(request["url"], str):
            print(request["method"], request["url"])
        else:
            print(request["method"], request["url"]["raw"])
        if "header" in request:
            for header in request["header"]:
                print(header["key"] + ":", header["value"])
        if "body" in request:
            print("Content-Type: application/json")
            print()
            if "raw" in request["body"]:
                body = json.loads(request["body"]["raw"])
                print(json.dumps(body, indent=2))
            elif "formdata" in request["body"]:
                body = dict(((el["key"], toInt(el["value"]))
                             for el in request["body"]["formdata"]))
                print(json.dumps(body, indent=2))

data = json.load(open(sys.argv[1], "rt", encoding="utf-8"))
if "info" in data:
    print("# " + data["info"]["name"])

for item in data["item"]:
    print("###")
    print("# @name", item["name"])
    if "item" in item:
        for subitem in item["item"]:
            print("###")
            print("# @name", subitem["name"])
            print_request(subitem)
    else:
        print_request(item)
    print()
