const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const userController = require("../controllers/user.controller");

router.get("/:id/stats", auth, userController.getUserStats);
router.get("/:id/current-focus", auth, userController.getCurrentFocus);

module.exports = router;
