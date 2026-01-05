import json
from googleapiclient.discovery import build

API_KEY = "AIzaSyBRfN3uEWxDMb2N2EWd5O2tXnZ-OHkYD_0"
CHANNEL_ID = "UCoGIPQ7M4NWai7LRgRhaSOg"

youtube = build('youtube', 'v3', developerKey=API_KEY)

# Get uploads playlist ID
resp = youtube.channels().list(
    part='contentDetails',
    id=CHANNEL_ID
).execute()
uploads_playlist_id = resp['items'][0]['contentDetails']['relatedPlaylists']['uploads']

video_ids = []
next_page_token = None
page = 1

print("Starting fetch of video IDs...")

while True:
    pl_request = youtube.playlistItems().list(
        part='contentDetails',
        playlistId=uploads_playlist_id,
        maxResults=50,
        pageToken=next_page_token
    )
    pl_response = pl_request.execute()

    for item in pl_response['items']:
        video_ids.append(item['contentDetails']['videoId'])

    print(f"Fetched page {page}, total IDs so far: {len(video_ids)}")
    page += 1

    next_page_token = pl_response.get('nextPageToken')
    if not next_page_token:
        break

# Save only the IDs
with open('videos.json', 'w', encoding='utf-8') as f:
    json.dump(video_ids, f, ensure_ascii=False, indent=2)

print(f"Done! Total videos fetched: {len(video_ids)}")
