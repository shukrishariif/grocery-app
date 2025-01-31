const mongoose = require("mongoose");

const ContactMessageSchema = new mongoose.Schema({
  name: String,
  email: String,
  phone: String,
  message: String,
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("ContactMessage", ContactMessageSchema);

