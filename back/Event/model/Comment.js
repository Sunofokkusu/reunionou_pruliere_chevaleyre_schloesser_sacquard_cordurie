const db = require('../db/dbConnexion');
const { v4: uuidv4 } = require("uuid");

async function addComment(idEvent, idUser, name, comment) {
    try {
        const result = await db('comment').insert({
            id: uuidv4(),
            id_event: idEvent,
            id_user: idUser,
            name: name,
        });
        if (!result) {
            return { error: "Error adding comment" };
        }
        return result;
    } catch (err) {
        console.log(err);
        return { error: "Error adding comment" };
    }
}

module.exports = {
    addComment
}