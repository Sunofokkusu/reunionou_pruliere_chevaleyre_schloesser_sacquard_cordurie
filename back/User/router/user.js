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
        info(`L'utilisateur :  ${name} à crée un compte`)
        res.json({ token : token.token });
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.post('/signin', userLoginValidator, async (req, res, next) => {
    try{
        const {email , password} = req.body;
        let token = await User.login(email, password);
        if (token.error) {
            return next({ error: 400, message: token.error });
        }
        res.json({ token : token.token });
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.post("/validate", async (req, res, next) => {
    console.log("validate");
    try{
        const authorization = req.headers.authorization;
        if (!authorization) {
            return next({ error: 401, message: "Non autorisé" });
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
        next({ error: 500, message: "Erreur serveur" });
    }
});


router.get("/:id", async (req, res, next) => {
    try{
        const {id} = req.params;
        let result = await User.getUser(id);
        if (result.error) {
            return next({ error: 400, message: result.error });
        }
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.put("/", async (req, res, next) => {
    try{
        const {id , name , password , newPassword} = req.body;
        let result = await User.updateUser(id, name, password, newPassword);
        if (result.error) {
            return next({ error: 400, message: result.error });
        }
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});


module.exports = router;