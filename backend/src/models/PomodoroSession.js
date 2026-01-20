const mongoose = require("mongoose");

const SessionSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  task: { type: mongoose.Schema.Types.ObjectId, ref: "Task" },
  cycle_number: Number,
  type: { type: String, enum: ["focus", "short_break", "long_break"] },
  durasi: Number,
  status: String,
  start_time: Date,
  end_time: Date
}, { timestamps: true });

module.exports = mongoose.model("PomodoroSession", SessionSchema);
