const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const taskController = require("../controllers/task.controller");

// SEMUA ROUTE TASK DIPROTEKSI
router.post("/", auth, taskController.createTask);
router.get("/", auth, taskController.getTasks);
router.put("/:id", auth, taskController.updateTask);
router.delete("/:id", auth, taskController.deleteTask);

module.exports = router;
