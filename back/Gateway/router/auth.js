const express = require("express");
const router = express.Router();
const axios = require("axios");

router.post("/signup", async (req, res, next) => {
  axios
    .post(process.env.USER_SERVICE + "signup", req.body)
    .then((response) => {
      res.header("Authorization", response.headers.authorization);
      res.redirect("http://localhost:8080");
    })
    .catch((err) => {
      console.log(err.response.data);
      next(err.response.data);
    });
});

module.exports = router;
