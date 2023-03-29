const db = require('../db/dbConnexion');
const { v4: uuidv4 } = require("uuid");

async function addComment(idEvent, idUser, name, comment) {
    try {
        const result = await db('comment').insert({
            id: uuidv4(),
            id_event: idEvent,
            id_user: idUser,
            name: name,
            comment: comment
        });
        if (!result) {
            return { error: "Error adding comment" };
        }
        return result;
    } catch (err) {
        return { error: "Error adding comment" };
    }
}

async function getComments(idEvent) {
    try {
        const result = await db('comment').where({ id_event: idEvent });
        if (!result) {
            return { error: "Error getting comments" };
        }
        return result;
    } catch (err) {
        return { error: "Error getting comments" };
    }
}



module.exports = {
    addComment,
    getComments
}