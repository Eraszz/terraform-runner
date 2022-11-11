import json
import requests

def lambda_handler(event, context):

    r = requests.get('https://performance-data.integration.meinestadt.de/campaign-performance-raw/')

    print(r.text)
    
    r = requests.get('https://performance-data.integration.meinestadt.de/campaign-performance-aggregated/')

    print(r.text)

    r = requests.get('https://performance-data.integration.meinestadt.de/campaign-performance-raw/1/')

    print(r.text)
    
    r = requests.get('https://performance-data.integration.meinestadt.de/campaign-performance-aggregated/1/')

    print(r.text)
