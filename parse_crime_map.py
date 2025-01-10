from bs4 import BeautifulSoup
import json
import os

def parse_crime_data():
    # Get the absolute path to the JSON file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(current_dir, 'assets', 'https___communitycrimemap_com_.json')
    
    print(f"Looking for file at: {json_path}")
    
    try:
        # Read the JSON file
        with open(json_path, 'r') as file:
            data = json.load(file)
            print("\nSuccessfully loaded JSON file")
            
        # Get the HTML content from the JSON
        html_content = data['html']
        print("\nParsing HTML content...")
        
        # Parse with BeautifulSoup
        soup = BeautifulSoup(html_content, 'html.parser')
        
        print("\n=== CRIME DATA ===")
        # Find all crime markers
        crime_markers = soup.find_all(class_='crime-marker')
        print(f"\nFound {len(crime_markers)} crime markers")
        
        for i, marker in enumerate(crime_markers, 1):
            try:
                crime_type = marker.get('data-type', '')
                location = marker.get('data-location', '')
                date = marker.get('data-date', '')
                lat = marker.get('data-lat', '')
                lng = marker.get('data-lng', '')
                
                print(f"""
Crime #{i}:
-----------
Type: {crime_type}
Location: {location}
Date: {date}
Coordinates: {lat}, {lng}
                """)
            except Exception as e:
                print(f"Error parsing marker #{i}: {e}")

        print("\n=== CATEGORIES ===")
        categories = soup.find_all(class_='crime-category')
        for cat in categories:
            print(f"Category: {cat.text.strip()}")

        print("\n=== FILTERS ===")
        filters = soup.find_all(class_='crime-filter')
        for f in filters:
            print(f"Filter: {f.text.strip()}")

    except FileNotFoundError:
        print(f"Error: Could not find file at {json_path}")
    except json.JSONDecodeError:
        print("Error: Invalid JSON file")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    parse_crime_data() 