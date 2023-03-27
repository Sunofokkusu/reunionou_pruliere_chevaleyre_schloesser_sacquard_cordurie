const db = require('../db/dbConnexion');


async function getEventUser(id) {
    const result = await db('events').where({ id_creator: id });
    if (!result) {
        return { error: 'Error getting events' };
    }
    return result;
}

module.exports = {
    getEventUser
}