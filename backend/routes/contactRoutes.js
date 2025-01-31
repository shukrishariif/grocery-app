const express = require("express");
const ContactMessage = require("../models/ContactMessage");

const router = express.Router();

// Send a Message
router.post("/", async (req, res) => {
  const contactMessage = new ContactMessage(req.body);
  await contactMessage.save();
  res.status(201).json({ message: "Message sent successfully" });
});

module.exports = router;
