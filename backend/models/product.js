const mongoose = require("mongoose");

const ProductSchema = new mongoose.Schema({
  name: String,
  category: String,
  price: Number,
  image: String,
  stock: Number,
  description: String,
});

module.exports = mongoose.model("Product", ProductSchema);
