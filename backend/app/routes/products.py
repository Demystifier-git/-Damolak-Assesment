from fastapi import APIRouter
from app.database import db
from app.models import Product

router = APIRouter()

@router.get("/")
def get_products():
    products = list(db.products.find({}, {"_id": 0}))
    return products

@router.post("/")
def create_product(product: Product):
    db.products.insert_one(product.dict())
    return {"message": "Product added"}