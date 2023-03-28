const express = require('express');
const router = express.Router();

// Model
const User = require('../model/User');

// Validator
const { userInsertValidator, userLoginValidator } = require('../validator/userValidator');

// Logger

const {info , error} = require('../helper/logger');

router.post('/signup', userInsertValidator, async (req, res, next) => {
    try{
        const {email , name , password} = req.body;
        let token = await User.signup(name, email, password);
        if (token.error) {
            return next({ error: 400, message: token.error });
        }
        info(`User ${name} signed up successfully.`)
        res.header("Authorization", "Bearer " + token.token).json({ token : "Bearer " + token.token });
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Internal server error" });
    }
});

router.post('/signin', userLoginValidator, async (req, res, next) => {
    try{
        const {email , password} = req.body;
        let token = await User.login(email, password);
        if (token.error) {
            return next({ error: 400, message: token.error });
        }
        res.header("Authorization", "Bearer " + token.token).json({ token : "Bearer " + token.token });
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Internal server error" });
    }
});

router.post("/validate", async (req, res, next) => {
    try{
        const authorization = req.headers.authorization;
        if (!authorization) {
            return next({ error: 401, message: "Unauthorized" });
        }
        const token = authorization.split(" ")[1];
        let result = await User.validate(token);
        if (result.error) {
            return next({ error: 401, message: result.error });
        }
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Internal server error" });
    }
});


module.exports = router;