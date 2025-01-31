const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phone: { type: String },
    address: { type: String },
  },
  { timestamps: true }
);

// ✅ Fix: Prevent model overwrite error
const User = mongoose.models.User || mongoose.model("User", userSchema);

module.exports = User;
