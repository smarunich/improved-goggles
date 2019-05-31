#!/usr/bin/env python
import requests
import datetime
import json
import sys
import redis
import os

def get_url(url):
    response = requests.get(url,headers={'Metadata':'true'})
    try:
        response.raise_for_status()
    except:
        return None
    try:
        return response.json()
    except ValueError:
        return response.text

redis_host = sys.argv[1]
identity = get_url('http://169.254.169.254/metadata/instance?api-version=2017-08-01')
print identity
identity['Name'] = identity['compute']['name']
identity['privateIp'] = identity['network']['interface'][0]['ipv4']['ipAddress'][0]['privateIpAddress']
identity['public-ipv4'] = identity['network']['interface'][0]['ipv4']['ipAddress'][0]['publicIpAddress']
identity['now'] = datetime.datetime.now().isoformat()
identity['localhostname'] = os.uname()[1]

report = { identity['compute']['name']: identity }
r = redis.client.StrictRedis(host=redis_host, port=6379, db=0)
r.publish('instances', json.dumps(report))
