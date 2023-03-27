const express = require('express');
const router = express.Router();

// Model
const User = require('../model/User');

// Validator
const { userInsertValidator } = require('../validator/userValidator');

router.post('/signup', userInsertValidator, async (req, res, next) => {
    try{
        const {email , name , password} = req.body;
        let token = await User.signup(name, email, password);
        if (token.error) {
            return next({ error: 400, message: token.error });
        }
        res.header("Authorization", "Bearer " + token).json({ token : "Bearer " + token });
    }
    catch(err){
        next({ error: 500, message: err.message });
    }
});


module.exports = router;