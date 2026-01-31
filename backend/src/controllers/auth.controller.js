const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const connectDB = require("../config/db");

exports.register = async (req, res) => {
  try {
    await connectDB();
    const { username, password, first_name, last_name, email } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: "Username & password wajib" });
    }

    const exist = await User.findOne({ username });
    if (exist) {
      return res.status(400).json({ message: "Username sudah terdaftar" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      username,
      password: hashedPassword,
      first_name,
      last_name,
      email,
    });
    if (!username || !password || !first_name || !last_name || !email) {
      return res.status(400).json({ message: "Data tidak lengkap" });
    }

    res.status(201).json({ message: "Register berhasil" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: "Data tidak lengkap" });
    }

    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ message: "User tidak ditemukan" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Password salah" });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1d",
    });

    res.json({
      message: "Login berhasil",
      token,
      user: {
        id: user._id,
        username: user.username,
        first_name: user.first_name,
        last_name: user.last_name,
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
