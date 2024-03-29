const db = require("../db/dbConnexion");
const { v4: uuidv4 } = require("uuid");
const randToken = require("rand-token");

async function getEventUser(id) {
  const result = await db("events").where({ id_creator: id });
  if (!result) {
    return { error: "Error getting events" };
  }
  return result;
}

async function createEvent(id, title, adress, description, date, lat, long) {
  let idEvent = uuidv4();
  const result = await db("events").insert({
    id: idEvent,
    id_creator: id,
    title: title,
    adress: adress,
    description: description,
    date: new Date(date),
    lat: lat,
    long: long,
  }).returning("id");
  if (!result) {
    return { error: "Error creating event" };
  }
  return { id: idEvent}
}

async function getEvent(id) {
  try{
    const result = await db("events").where({ id : id }).first();
    if (!result) {
      return { error: 404, message: "Evenement non trouvé" };
    }
    return result;
  }catch(err){
    console.log(err);
    return { error: "Error getting event" };
  }
}


async function deleteEvent(id) {
  try{
    const result = await db("events").where({ id: id }).del();
    const suppressionParticipant = await db("participant").where({ id_event: id }).del();
    const suppressionComment = await db("comment").where({ id_event: id }).del();
    if (!result) {
      return { error: "Error deleting event" };
    }
    return result;
  }catch(err){
    console.log(err);
    return { error: "Error deleting event" };
  }
}

async function updateEvent(id, idUser, title, adress, description, date, lat, long) {
  const event = await db("events").where({ id: id }).first();
  if (!event) {
    return { error: "Event not found" };
  }
  if (event.id_creator !== idUser) {
    return { error: "You are not the creator of this event" };
  }
  const result = await db("events").where({ id: id }).update({
    title: title,
    adress: adress,
    description: description,
    date: new Date(date),
    lat: lat,
    long: long,
  });
  if (!result) {
    return { error: "Error updating event" };
  }
  return { id: id }
}

module.exports = {
  getEventUser,
  createEvent,
  getEvent,
  deleteEvent,
  updateEvent,
};
