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
            console.log("Error adding comment top");
            return { error: "Error adding comment" };
        }
        return result;
    } catch (err) {
        console.log("Error adding comment");
        return { error: "Error adding comment" };
    }
}

module.exports = {
    addComment
}