const express = require('express');
const router = express.Router();

const Event = require('../model/event');

// Logger
const { info, error } = require('../helper/logger');

router.post('/', async (req, res, next) => {
    console.log(req.body);
    try{
        const {id, title, description, date, adress, lat, long} = req.body;
        let result = await Event.createEvent(id, title,adress, description, date, lat, long);
        if (result.error) {
            return next({ error: 400, message: result.error });
        }
        info(`L'utilisateur :  ${id} à crée un évenement`);
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

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
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});



module.exports = router;