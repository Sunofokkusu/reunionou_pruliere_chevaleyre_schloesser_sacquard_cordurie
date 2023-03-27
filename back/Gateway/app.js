const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.json({ message: "Hello from Gateway!" });
});

app.listen(process.env.PORT, () => {
  console.log(`Gateway is listening on port ${process.env.PORT}!`);
});
