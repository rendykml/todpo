const PomodoroSession = require("../models/PomodoroSession");
const Task = require("../models/Task");

exports.createSession = async (req, res) => {
  try {
    const {
      taskId,
      cycle_number,
      type,
      durasi,
      status
    } = req.body;

    // 1. Simpan session
    const session = await PomodoroSession.create({
      user: req.user.id,
      task: taskId,
      cycle_number,
      type,
      durasi,
      status,
      start_time: new Date(),
      end_time: new Date()
    });

    // 2. Jika focus → update progress task
    if (type === "focus" && status === "selesai") {
      await Task.findOneAndUpdate(
        { _id: taskId, user: req.user.id },
        { $inc: { completed_cycle: 1 } }
      );
    }

    res.status(201).json(session);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.getMySessions = async (req, res) => {
  try {
    const sessions = await PomodoroSession.find({
      user: req.user.id
    })
      .populate("task", "judul_task")
      .sort({ createdAt: -1 });

    res.json(sessions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

