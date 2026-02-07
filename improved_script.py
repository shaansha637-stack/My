import requests
import json
from bs4 import BeautifulSoup
import sys
import time
import os

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def fetch_instagram_profile(username, timeout=10):
    """Fetch Instagram profile with better error handling."""
    url = "https://privatephotoviewer.com/wp-json/instagram-viewer/v1/fetch-profile"
    payload = {"find": username}
    headers = {
        "User-Agent": "Mozilla/5.0 (Linux; Android 11) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.97 Mobile Safari/537.36",
        "Content-Type": "application/json",
    }

    try:
        response = requests.post(url, json=payload, headers=headers, timeout=timeout)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        raise Exception(f"Network error: {str(e)}")

    data = response.json()
    html = data.get("html", "")
    
    if not html:
        raise Exception("No HTML data returned from API")

    return parse_profile_html(html)

def parse_profile_html(html):
    """Parse profile information from HTML."""
    soup = BeautifulSoup(html, "html.parser")
    try:
        name = soup.select_one("h4.text-muted").text.strip()
        username = soup.select_one("h5.text-muted").text.strip()
        
        strong_tags = soup.select("div.text-center strong")
        if len(strong_tags) < 3:
            raise Exception("Unexpected HTML structure")
        
        posts = strong_tags[0].text.strip()
        followers = strong_tags[1].text.strip()
        following = strong_tags[2].text.strip()
        
        profile_pic_tag = soup.select_one("img")
        if not profile_pic_tag or not profile_pic_tag.get("src"):
            raise Exception("Profile picture not found")
        
        profile_pic = profile_pic_tag["src"]
        bio = soup.select_one("p").text.strip()
        
    except Exception as e:
        raise Exception(f"Failed to parse profile HTML: {str(e)}")

    return {
        "name": name,
        "username": username,
        "posts": posts,
        "followers": followers,
        "following": following,
        "bio": bio,
        "profile_pic": profile_pic
    }

def print_template(info):
    """Display profile information in formatted output."""
    print("\n" + "="*60)
    print(f"📸  INSTAGRAM PROFILE VIEWER")
    print("="*60)
    print(f"👤 Name       : {info['name']}")
    print(f"🔖 Username   : {info['username']}")
    print(f"📝 Posts      : {info['posts']}")
    print(f"👥 Followers  : {info['followers']}")
    print(f"🔗 Following  : {info['following']}")
    print(f"💬 Bio        : {info['bio']}")
    print(f"🖼️ Profile Pic: {info['profile_pic']}")
    print("="*60 + "\n")

if __name__ == "__main__":
    clear()
    print("🔍 Instagram Private Profile Fetcher (Unofficial API)")
    username = input("Enter Instagram username: ").strip()

    if not username:
        print("❌ Username cannot be empty.")
        sys.exit(1)

    print("\n⏳ Fetching profile info, please wait...\n")
    try:
        info = fetch_instagram_profile(username)
        print_template(info)
    except Exception as e:
        print(f"⚠️  Error: {str(e)}")
        sys.exit(1)