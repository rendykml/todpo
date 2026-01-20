const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  nama: String,
  email: String
}, { timestamps: true });

module.exports = mongoose.model("User", UserSchema);
