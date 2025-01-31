// backend/controllers/shoppingCartCon.js
import ShoppingCart from '../models/shoppingCart.js';
import Product from '../models/productModel.js';

// Create or update a shopping cart for a user
export const createOrUpdateCart = async (req, res) => {
  try {
    const { items } = req.body;
    const user_id = req.user._id;

    let cart = await ShoppingCart.findOne({ user_id });

    if (!cart) {
      cart = new ShoppingCart({ user_id, items });
    } else {
      cart.items = items; // Update items
    }

    await cart.save();
    res.status(200).json({ message: 'Cart updated successfully', cart });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get the shopping cart for a user
export const getCart = async (req, res) => {
  try {
    const user_id = req.params.user_id;
    const cart = await ShoppingCart.findOne({ user_id }).populate('items.product_id');

    if (!cart) {
      return res.status(404).json({ message: 'Shopping cart not found!' });
    }

    return res.status(200).json({ cart });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// Add item to cart
export const addItemToCart = async (req, res) => {
  try {
    const { product_id, quantity } = req.body;
    const user_id = req.user._id;

    // Validate product exists
    const product = await Product.findById(product_id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    let cart = await ShoppingCart.findOne({ user_id });

    if (!cart) {
      cart = new ShoppingCart({
        user_id,
        items: [],
      });
    }

    // Check if product already in cart
    const existingItem = cart.items.find(item => item.product_id.toString() === product_id);

    if (existingItem) {
      existingItem.quantity += quantity; // Update quantity
    } else {
      cart.items.push({ product_id, quantity }); // Add new item
    }

    await cart.save();
    res.status(200).json({ message: 'Item added to cart successfully', cart });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Remove item from cart
export const removeItemFromCart = async (req, res) => {
  try {
    const { product_id } = req.body;
    const user_id = req.user._id;

    const cart = await ShoppingCart.findOne({ user_id });

    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }

    // Filter out the item to be removed
    cart.items = cart.items.filter(item => item.product_id.toString() !== product_id);

    await cart.save();
    res.status(200).json({ message: 'Item removed from cart successfully', cart });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Clear cart
export const clearCart = async (req, res) => {
  try {
    const user_id = req.user._id;

    const cart = await ShoppingCart.findOne({ user_id });

    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }

    // Clear the items in the cart
    cart.items = [];
    await cart.save();

    res.status(200).json({ message: 'Cart cleared successfully', cart });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};