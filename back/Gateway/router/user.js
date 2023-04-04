const express = require("express");
const router = express.Router();
const axios = require("axios");

router.get("/me", async (req, res, next) => {
  try {
    if (!req.headers.authorization) return next({ error: 401, message: "Unauthorized" });
    let validate = await axios.post(
      process.env.USER_SERVICE + "validate",
      {},
      {
        headers: {
          Authorization: req.headers.authorization,
        },
      }
    );
    console.log("here 1");
    let events = await axios.get(
      process.env.EVENT_SERVICE + "user/" + validate.data.id
    );
    let invited = await axios.get(
      process.env.EVENT_SERVICE + "user/" + validate.data.id + "/invited"
    );
    console.log("here 2");
    for (let i = 0; i < events.data.length; i++) {
      let creator = await axios.get(
        process.env.USER_SERVICE + events.data[i].id_creator
      );
      events.data[i].creator = {
        name: creator.data.name,
        email: creator.data.email,
      };
    }
    for (let i = 0; i < invited.data.length; i++) {
      let creator = await axios.get(
        process.env.USER_SERVICE + invited.data[i].id_creator
      );
      invited.data[i].creator = {
        name: creator.data.name,
        email: creator.data.email,
      };
    }
    if (req.query.embed === "events") {
      res.json({
        id: validate.data.id,
        name: validate.data.name,
        mail: validate.data.email,
        events: events.data,
      });
    } else if (req.query.embed === "invited") {
      res.json({
        id: validate.data.id,
        name: validate.data.name,
        mail: validate.data.email,
        invited: invited.data,
      });
    } else if (req.query.embed === "all") {
      res.json({
        id: validate.data.id,
        name: validate.data.name,
        mail: validate.data.email,
        events: events.data.concat(invited.data),
      });
    } else {
      res.json({
        id: validate.data.id,
        name: validate.data.name,
        mail: validate.data.email,
      });
    }
  } catch (err) {
    console.log(err);
    return next(err.response.data);
  }
});

router.put("/", async (req, res, next) => {
  try {
    if (!req.headers.authorization)
      return next({ error: 401, message: "Unauthorized" });
    let validate = await axios.post(
      process.env.USER_SERVICE + "validate",
      {},
      {
        headers: {
          Authorization: req.headers.authorization,
        },
      }
    );
    let user = await axios.put(
      process.env.USER_SERVICE,
      {
        id: validate.data.id,
        name: req.body.name,
        password: req.body.password,
        newPassword: req.body.newPassword,
      },
      {
        headers: {
          Authorization: req.headers.authorization,
        },
      }
    );
    res.json(user.data);
  } catch (err) {
    console.log(err);
    return next(err.response.data);
  }
});

module.exports = router;
