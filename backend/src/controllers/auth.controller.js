const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
  try {
    const { username, password, nama, email } = req.body;

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
      nama,
      email
    });

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

    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.json({
      message: "Login berhasil",
      token,
      user: {
        id: user._id,
        username: user.username,
        nama: user.nama
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
