const express = require('express');
const router = express.Router();

const Event = require('../model/event');


router.get('/user/:id', async (req, res, next) => {
    try{
        const {id} = req.params;
        let result = await Event.getEventUser(id);
        if (result.error) {
            return next({ error: 400, message: result.error });
        }
        res.json(result);
    }
    catch(err){
        next({ error: 500, message: "Internal server error" });
    }
});

module.exports = router;