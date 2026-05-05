from fastapi import APIRouter
from app.database import db
from app.models import User

router = APIRouter()

@router.post("/signup")
def signup(user: User):
    db.users.insert_one(user.dict())
    return {"message": "User created"}