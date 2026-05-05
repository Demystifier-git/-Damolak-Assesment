
db = db.getSiblingDB("minishop");


db.createCollection("products");
db.createCollection("users");


db.products.insertMany([
  {
    name: "Laptop",
    price: 1200
  },
  {
    name: "Phone",
    price: 800
  },
  {
    name: "Headphones",
    price: 150
  }
]);


db.users.insertOne({
  username: "admin",
  password: "admin123" // ⚠️ plain text for demo only
});


db.users.createIndex({ username: 1 }, { unique: true });
db.products.createIndex({ name: 1 });


print("✅ Database initialized successfully");