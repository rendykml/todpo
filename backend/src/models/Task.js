const mongoose = require("mongoose");

const TaskSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  judul_task: String,
  deskripsi: String,
  start_date: Date,
  deadline: Date,
  schedule_type: { type: String, enum: ["daily", "weekly", "once"] },
  target_cycle: Number,
  completed_cycle: { type: Number, default: 0 },
  priority: String,
  status: { type: String, default: "ongoing" },
  visibility: { type: String, enum: ["private", "public"], default: "private" }
}, { timestamps: true });

module.exports = mongoose.model("Task", TaskSchema);
