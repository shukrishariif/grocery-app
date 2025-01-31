const express = require("express");
const {
  registerUser,
  loginUser,
  getUserProfile,
  updateUserProfile, // Ensure this function exists in userController.js
} = require("../controllers/userController");

const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

// Register User
router.post("/register", registerUser);

// Login User
router.post("/login", loginUser);

// Get User Profile (Protected)
router.get("/profile", protect, getUserProfile);

// Update User Profile (Protected)
router.put("/profile", protect, updateUserProfile);

module.exports = router; // Ensure the router is exported properly