const Task = require("../models/Task");

exports.createTask = async (req, res) => {
  try {
    const task = await Task.create({
      ...req.body,
      user: req.user.id,
    });
    res.status(201).json(task);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.getTasks = async (req, res) => {
  try {
    const tasks = await Task.find({
      user: req.user.id,
    }).sort({ createdAt: -1 });

    res.json(tasks);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getPublicTasks = async (req, res) => {
  try {
    const tasks = await Task.find({
      user: req.params.userId,
      visibility: "public",
    }).select("judul_task schedule_type start_date deadline");
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateTask = async (req, res) => {
  try {
    const task = await Task.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      req.body,
      { new: true },
    );

    if (!task) return res.status(404).json({ message: "Task tidak ditemukan" });

    res.json(task);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.deleteTask = async (req, res) => {
  try {
    const task = await Task.findOneAndDelete({
      _id: req.params.id,
      user: req.user.id,
    });

    if (!task) return res.status(404).json({ message: "Task tidak ditemukan" });

    res.json({ message: "Task berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
