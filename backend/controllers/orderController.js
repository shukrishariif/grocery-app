const Order = require("../models/orderModel");
const Cart = require("../models/cartModel");

// ✅ Create Order from Cart
const createOrder = async (req, res) => {
  try {
    const userId = req.user.id;

    // ✅ Find the user's cart
    const cart = await Cart.findOne({ user: userId }).populate("items.product");

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: "Cart is empty" });
    }

    // ✅ Create an order from cart
    const order = new Order({
      user: userId,
      items: cart.items.map((item) => ({
        product: item.product._id,
        quantity: item.quantity,
        price: item.product.price,
      })),
      totalAmount: cart.totalPrice,
      status: "Pending",
    });

    // ✅ Save order and clear the cart
    await order.save();
    await Cart.findOneAndDelete({ user: userId });

    res.status(201).json({ message: "Order placed successfully", order });
  } catch (error) {
    res.status(500).json({ message: "Error creating order", error: error.message });
  }
};

module.exports = { createOrder };
