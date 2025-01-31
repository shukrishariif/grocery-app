import ShoppingCart from '../models/shoppingCart.js';
import Product from '../models/productModel.js';

// Create or update cart
export const createOrUpdateCart = async (req, res) => {
  try {
    const { items } = req.body;
    const user_id = req.user._id;

    let cart = await ShoppingCart.findOne({ user_id });

    if (!cart) {
      cart = new ShoppingCart({
        user_id,
        items: [],
        totalAmount: 0
      });
    }

    cart.items = items;
    await cart.save();

    res.status(200).json({
      message: cart.isNew ? 'Cart created successfully' : 'Cart updated successfully',
      cart
    });
  } catch (error) {
    console.error('Create/Update cart error:', error);
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// Get cart
export const getCart = async (req, res) => {
  try {
    const user_id = req.user._id;
    const cart = await ShoppingCart.findOne({ user_id })
      .populate('items.product_id');

    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }

    res.status(200).json({ cart });
  } catch (error) {
    console.error('Get cart error:', error);
    res.status(500).json({ message: 'Server Error', error: error.message });
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
        totalAmount: 0
      });
    }

    // Check if product already in cart
    const existingItem = cart.items.find(
      item => item.product_id.toString() === product_id
    );

    if (existingItem) {
      existingItem.quantity += quantity;
    } else {
      cart.items.push({ product_id, quantity });
    }

    await cart.save();
    
    // Populate product details before sending response
    const populatedCart = await cart.populate('items.product_id');

    res.status(200).json({
      message: 'Item added to cart successfully',
      cart: populatedCart
    });
  } catch (error) {
    console.error('Add to cart error:', error);
    res.status(500).json({ message: 'Server Error', error: error.message });
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

    cart.items = cart.items.filter(
      item => item.product_id.toString() !== product_id
    );

    await cart.save();
    
    // Populate product details before sending response
    const populatedCart = await cart.populate('items.product_id');

    res.status(200).json({
      message: 'Item removed from cart successfully',
      cart: populatedCart
    });
  } catch (error) {
    console.error('Remove from cart error:', error);
    res.status(500).json({ message: 'Server Error', error: error.message });
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

    cart.items = [];
    await cart.save();

    res.status(200).json({
      message: 'Cart cleared successfully',
      cart
    });
  } catch (error) {
    console.error('Clear cart error:', error);
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};