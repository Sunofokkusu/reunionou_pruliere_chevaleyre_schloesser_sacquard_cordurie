const express = require("express");
const app = express();
const cors = require("cors");

// app.use((req , res , next) => {
//   res.header("Access-Control-Allow-Origin", req.headers.origin);
//   res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, ngrok-skip-browser-warning");
//   next();
// });

app.use(express.json());

app.use("/auth", require("./router/auth"));
app.use("/event", require("./router/event"));
app.use("/user", require("./router/user"));

const { errorhandler } = require("./handler/errorHandler");
app.use(errorhandler);

app.listen(process.env.PORT, () => {
  console.log(`Gateway is listening on port ${process.env.PORT}!`);
});
