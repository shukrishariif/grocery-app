// backend/routes/shoppingCartRo.js
import express from 'express';
import { 
  createOrUpdateCart, 
  getCart, 
  addItemToCart, 
  removeItemFromCart, 
  clearCart 
} from '../controllers/shoppingCartCon.js';
import { protect } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protect all routes
router.use(protect);

// Create or update a shopping cart
router.post('/', createOrUpdateCart);

// Get the shopping cart for a user by user_id
router.get('/:user_id', getCart);

// Add an item to the cart
router.post('/add-item', addItemToCart);

// Remove an item from the cart
router.post('/remove-item', removeItemFromCart);

// Clear the cart
router.delete('/clear', clearCart);

export default router;