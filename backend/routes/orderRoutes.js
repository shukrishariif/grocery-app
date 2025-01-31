const express = require('express');
const router = express.Router();
const Order = require('../models/orderModel'); // ✅ Ensure this file exists
const { protect } = require('../middleware/authMiddleware'); // ✅ Check if middleware exists

// ✅ Create an Order
router.post('/', protect, async (req, res) => {
  try {
    const { orderItems, totalPrice } = req.body;

    if (!orderItems || orderItems.length === 0) {
      return res.status(400).json({ message: 'No order items' });
    }

    const order = new Order({
      user: req.user._id,
      orderItems,
      totalPrice,
    });

    const createdOrder = await order.save();
    res.status(201).json(createdOrder);
  } catch (error) {
    res.status(500).json({ message: 'Error creating order', error: error.message });
  }
});

module.exports = router;
