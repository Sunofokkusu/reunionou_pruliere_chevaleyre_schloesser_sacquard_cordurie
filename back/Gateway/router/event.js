const express = require("express");
const router = express.Router();
const axios = require("axios");


router.post("/", async (req, res, next) => {
    try{
        if(!req.headers.authorization) return next({error : 401, message : "Unauthorized"});
        let validate = await axios.post(process.env.USER_SERVICE + "validate", {}, {
            headers: {
                Authorization: req.headers.authorization
            }
        });
        let event = await axios.post(process.env.EVENT_SERVICE , {
            id : validate.data.id,
            title : req.body.title,
            description : req.body.description,
            date : req.body.date,
            adress : req.body.adress,
            lat : req.body.lat,
            long : req.body.long
        });
        res.json(event.data);
    }catch(err){
        try {
            return next(err.response.data);
        } catch (error) {
            return next(500);   
        }
    }
});

router.get("/:id", async (req, res, next) => {
    try{
        let event = await axios.get(process.env.EVENT_SERVICE + req.params.id);
        let creator = await axios.get(process.env.USER_SERVICE + event.data.id_creator);
        event.data.creator = creator.data;
        res.json(event.data);
    }catch(err){
        try {
            return next(err.response.data);
        } catch (error) {
            return next(500);   
        }
    }
});

router.post("/:id/participant", async (req, res, next) => {
    try{
        if(!req.headers.authorization) {
            let event = await axios.post(process.env.EVENT_SERVICE + req.params.id + "/participant", {
                name : req.body.name,
                status : req.body.status,
                message : req.body.message
            })
            res.json(event.data);
        }else{
            let validate = await axios.post(process.env.USER_SERVICE + "validate", {}, {
                headers: {
                    Authorization: req.headers.authorization
                }
            });
            let event = await axios.post(process.env.EVENT_SERVICE + req.params.id + "/participant", {
                id : validate.data.id,
                name : validate.data.name,
                status : req.body.status,
                message : req.body.message
            });
            res.json(event.data);
        }
    }catch(err){
        try {
            return next(err.response.data);
        } catch (error) {
            return next(500);   
        }
    }
});



module.exports = router;

