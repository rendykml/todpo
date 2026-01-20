const express = require("express");
const cors = require("cors");
const sessionRoutes = require("./routes/session.routes");
const authRoutes = require("./routes/auth.routes");
const taskRoutes = require("./routes/task.routes");
const userRoutes = require("./routes/user.routes");
const app = express();

app.use(cors());
app.use(express.json());

module.exports = app;

app.use("/api/tasks", taskRoutes);

app.use("/api/auth", authRoutes);

app.use("/api/sessions", sessionRoutes);

app.use("/api/users", userRoutes);
