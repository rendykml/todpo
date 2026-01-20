const PomodoroSession = require("../models/PomodoroSession");
const mongoose = require("mongoose");

exports.getUserStats = async (req, res) => {
  try {
    const userId = req.params.id;

    const now = new Date();

    const startOfDay = new Date(now.setHours(0, 0, 0, 0));
    const startOfWeek = new Date();
    startOfWeek.setDate(startOfWeek.getDate() - 6);
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const baseQuery = {
      user: new mongoose.Types.ObjectId(userId),
      type: "focus",
      status: "selesai",
    };

    const daily = await PomodoroSession.countDocuments({
      ...baseQuery,
      createdAt: { $gte: startOfDay },
    });

    const weekly = await PomodoroSession.countDocuments({
      ...baseQuery,
      createdAt: { $gte: startOfWeek },
    });

    const monthly = await PomodoroSession.countDocuments({
      ...baseQuery,
      createdAt: { $gte: startOfMonth },
    });

    const average = Number((weekly / 7).toFixed(1));

    res.json({
      daily,
      weekly,
      monthly,
      average,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getCurrentFocus = async (req, res) => {
  try {
    const userId = req.params.id;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const session = await PomodoroSession.findOne({
      user: userId,
      type: "focus",
      status: "selesai",
      createdAt: { $gte: today },
    })
      .sort({ createdAt: -1 })
      .populate("task", "judul_task");

    if (!session || !session.task) {
      return res.json({
        status: "idle",
      });
    }

    res.json({
      status: "focusing",
      title: session.task.judul_task,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
