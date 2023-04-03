const express = require('express');
const router = express.Router();

const Event = require('../model/Event');
const Participant = require('../model/participant');
const Comment = require('../model/comment');

const { info, error } = require('../helper/logger');

const { eventInsertValidator, participantInsertValidator, commentInsertValidator } = require('../validator/eventValidator');

router.post('/', eventInsertValidator, async (req, res, next) => {
    try{
        const {id, title, description, date, adress, lat, long} = req.body;
        let result = await Event.createEvent(id, title,adress, description, date, lat, long);
        if (result.error) {
            return next(500)
        }
        info(`L'utilisateur :  ${id} à crée un évenement`);
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.get('/:id', async (req, res, next) => {
    try{
        const {id} = req.params;
        let event = await Event.getEvent(id);
        if (event.error) {
            return next({ error: event.error, message: event.message });
        }
        let participant = await Participant.getEventParticipants(event.id);
        if (participant.error) {
            return next(500)
        }
        participant.forEach(element => {
            if(element.message == null) delete element.message;
        });
        let comment = await Comment.getComments(event.id);
        if (comment.error) {
            return next(500)
        }
        event.comments = comment;
        event.participants = participant;
        res.json(event);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.post('/:id/participant', participantInsertValidator, async (req, res, next) => {
    try{
        const idEvent = req.params.id;
        const {message} = req.body;
        let event = await Event.getEvent(idEvent);
        if (event.error) {
            return next(500);
        }
        const {id, name, status} = req.body;
        let participant = await Participant.addParticipant(event.id, id, name, status, message);
        if (participant.error) {
            return next(500)
        }
        res.json({
            "type" : "info",
            "message" : "Utilisateur ajouté"
        })
    }catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.post('/:id/comment', commentInsertValidator, async (req, res, next) => {
    try{
        const idEvent = req.params.id;
        const {message} = req.body;
        let event = await Event.getEvent(idEvent);
        if (event.error) {
            return next(event);
        }
        const {id, name} = req.body;
        let comment = await Comment.addComment(event.id, id, name, message);
        if (comment.error) {
            return next(500)
        }
        res.json({
            "type" : "info",
            "message" : "Commentaire ajouté"
        })
    }catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.get('/user/:id', async (req, res, next) => {
    try{
        const {id} = req.params;
        let result = await Event.getEventUser(id);
        if (result.error) {
            return next(500)
        }
        res.json(result);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

router.get('/user/:id/invited', async (req, res, next) => {
    try{
        const {id} = req.params;
        let result = await Participant.getInvitedEvents(id);
        if (result.error) {
            return next(500)
        }
        let events = [];
        for (let i = 0; i < result.length; i++) {
            let event = await Event.getEvent(result[i].id_event);
            if (event.error) {
                return next(500)
            }
            events.push(event);
        }
        res.json(events);
    }
    catch(err){
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});


router.delete('/:id', async (req, res, next) => {
    try{
        const {id} = req.params;
        let result = await Event.deleteEvent(id);
        if (result.error) {
            console.log(result);
            return next(500)
        }
        res.json(result);
    }
    catch(err){
        console.log(err);
        error(err.message);
        next({ error: 500, message: "Erreur serveur" });
    }
});

module.exports = router;