const express = require("express");
const app = express();
const cors = require("cors");

app.all("*", (req, res, next) => {
  console.log(req.headers.origin);
  res.header("Access-Control-Allow-Origin", req.headers.origin);
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Credentials", true);
  next();
});

// Body parser
app.use(express.json());

app.use("/", require("./router/event"));

// error handler
const { errorhandler } = require("./handler/errorhandler");
app.use(errorhandler);

app.listen(process.env.PORT, () => {
  console.log(`Event service listening on port ${process.env.PORT}`);
});
