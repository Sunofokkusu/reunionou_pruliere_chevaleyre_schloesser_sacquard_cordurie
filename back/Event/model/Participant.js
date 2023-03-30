const db = require('../db/dbConnexion');
const { v4: uuidv4 } = require("uuid");

function getEventParticipants(eventId) {
    try{
       return db('participant').where({ id_event : eventId }); 
    }catch(err){
        return {error : err};
    }
}

async function addParticipant(eventId, user, name, status, message){
    try{
        const result = await db('participant').insert({
            id : uuidv4(),
            id_event : eventId,
            id_user : user,
            name : name,
            status : status,
            message : message
        });
        if(!result){
            return {error : "Error adding participant" };
        }
        return result;
    }catch(err){
        return {error : "Error adding participant" };
    }
}

async function getInvitedEvents(id){
    try{
        const result = await db('participant').where({ id_user : id});
        if(!result){
            return {error : "Error getting events" };
        }
        return result;
    }catch(err){
        return {error : "Error getting events" };
    }
}



module.exports = {
    getEventParticipants,
    addParticipant,
    getInvitedEvents
}