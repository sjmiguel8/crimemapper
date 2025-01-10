from bs4 import BeautifulSoup
import json
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/parse-crime-data')
def parse_crime_data():
    with open('assets/https___communitycrimemap_com_.json', 'r') as file:
        data = json.load(file)
    
    html_content = data['html']
    soup = BeautifulSoup(html_content, 'html.parser')
    
    crimes = []
    markers = soup.find_all(class_='crime-marker')
    
    for marker in markers:
        crime = {
            'type': marker.get('data-type', ''),
            'location': marker.get('data-location', ''),
            'date': marker.get('data-date', ''),
            'latitude': marker.get('data-lat', ''),
            'longitude': marker.get('data-lng', ''),
        }
        crimes.append(crime)
    
    return jsonify(crimes)

if __name__ == '__main__':
    app.run(port=5000)