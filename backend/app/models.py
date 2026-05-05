from pydantic import BaseModel

class Product(BaseModel):
    name: str
    price: float

class User(BaseModel):
    username: str
    password: str