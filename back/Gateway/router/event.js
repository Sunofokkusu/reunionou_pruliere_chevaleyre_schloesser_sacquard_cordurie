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
        if( req.body.title == undefined || req.body.description == undefined || req.body.date == undefined || req.body.adress == undefined || req.body.lat == undefined || req.body.long == undefined ) return next({error : 400, message : "Bad request"});
        let event = await axios.post(process.env.EVENT_SERVICE , {
            id : validate.data.id,
            title : req.body.tile,
            description : req.body.description,
            date : req.body.date,
            adress : req.body.adress,
            lat : req.body.lat,
            long : req.body.long
        });
        res.json(event.data);
    }catch(err){
        console.log(err);
        return next(err.response.data);
    }
});



module.exports = router;

