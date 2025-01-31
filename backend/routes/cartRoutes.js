const express = require("express");
const { addToCart, getCart, removeFromCart, clearCart } = require("../controllers/cartController"); // ✅ Check this import
const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

// ✅ Route to get user's cart
router.get("/", protect, getCart);

// ✅ Route to add item to cart
router.post("/", protect, addToCart);

// ✅ Route to remove item from cart
router.delete("/:id", protect, removeFromCart);

// ✅ Route to clear entire cart
router.delete("/", protect, clearCart);

module.exports = router;
