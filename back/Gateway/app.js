const express = require("express");
const app = express();
const axios = require("axios");

app.use(express.json());

app.use("/auth", require("./router/auth"));

const { errorhandler } = require("./handler/errorHandler");
app.use(errorhandler);

app.listen(process.env.PORT, () => {
  console.log(`Gateway is listening on port ${process.env.PORT}!`);
});
