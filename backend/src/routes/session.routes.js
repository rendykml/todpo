const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const sessionController = require("../controllers/session.controller");

router.post("/", auth, sessionController.createSession);
router.get("/", auth, sessionController.getMySessions);

module.exports = router;
