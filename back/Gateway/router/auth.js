const express = require("express");
const router = express.Router();
const axios = require("axios");

router.post("/signup", async (req, res, next) => {
  axios
    .post(process.env.USER_SERVICE + "signup", req.body)
    .then((response) => {
      res.json(response.data);
    })
    .catch((err) => {
      next(err.response.data);
    });
});

router.post("/signin", async (req, res, next) => {
  axios
    .post(process.env.USER_SERVICE + "signin", req.body)
    .then((response) => {
      res.json(response.data);
    })
    .catch((err) => {
      next(err.response.data);
    });
});




module.exports = router;
