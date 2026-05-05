from pymongo import MongoClient
import os

MONGO_URI = os.environ.get("MONGO_URI")

if not MONGO_URI:
    raise ValueError("❌ MONGO_URI environment variable is not set")

client = MongoClient(MONGO_URI)
db = client["minishop"]