const express = require("express");
const app = express();
const cors = require("cors");

// app.use(cors({
//   origin: "*",
//   methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
//   preflightContinue: false,
//   optionsSuccessStatus: 204
// }));

app.use(express.json());

app.use("/auth", require("./router/auth"));
app.use("/event", require("./router/event"));
app.use("/user", require("./router/user"));

const { errorhandler } = require("./handler/errorHandler");
app.use(errorhandler);

app.listen(process.env.PORT, () => {
  console.log(`Gateway is listening on port ${process.env.PORT}!`);
});
