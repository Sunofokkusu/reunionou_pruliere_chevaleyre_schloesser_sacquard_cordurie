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
    token : randToken.generate(16)
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
      return { error: "Error getting event" };
    }
    return result;
  }catch(err){
    return { error: "Error getting event" };
  }
}

module.exports = {
  getEventUser,
  createEvent,
  getEvent
};
