const express = require("express");
const helmet = require("helmet");
const morgan = require("morgan");

const webhookRouter = require("./routes/webhook");

const app = express();

app.use(helmet());
app.use(morgan("combined"));
app.use(express.json());

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    uptime: process.uptime()
  });
});

app.use("/webhook", webhookRouter);

module.exports = app;