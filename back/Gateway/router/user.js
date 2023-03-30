const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/me', async (req, res, next) => {
    try{
        if(!req.headers.authorization) return next({error : 401, message : "Unauthorized"});
        let validate = await axios.post(process.env.USER_SERVICE + "validate", {}, {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        if(req.query.embed === "events"){
            let events = await axios.get(process.env.EVENT_SERVICE + "user/" + validate.data.id);
            res.json({
                name : validate.data.name,
                mail : validate.data.email,
                events : events.data
            });
        }else{
            res.json({
                id   : validate.data.id,
                name : validate.data.name,
                mail : validate.data.email,
            });
        }
    }catch(err){
        console.log(err);
        return next(err.response.data);
    }
});

router.put('/', async (req, res, next) => {
    try{
        if(!req.headers.authorization) return next({error : 401, message : "Unauthorized"});
        let validate = await axios.post(process.env.USER_SERVICE + "validate", {}, {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        let user = await axios.put(process.env.USER_SERVICE , {
            id : validate.data.id,
            name : req.body.name,
            password : req.body.password,
            newPassword : req.body.newPassword
        }, 
        {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        res.json(user.data);
    }catch(err){
        console.log(err);
        return next(err.response.data);
    }
});

router.post('/verifyPassword', async (req, res, next) => {
    try{
        if(!req.headers.authorization) return next({error : 401, message : "Unauthorized"});
        let validate = await axios.post(process.env.USER_SERVICE + "validate", {}, {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        let verify = await axios.post(process.env.USER_SERVICE + "verifyPassword", {
            id : validate.data.id,
            password : req.body.password
        },
        {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        res.json(verify.data);
    }catch(err){
        console.log(err);
        return next(err.response.data);
    }
});


module.exports = router;