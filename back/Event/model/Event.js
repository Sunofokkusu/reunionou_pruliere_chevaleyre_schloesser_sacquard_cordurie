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
  const result = await db("events").insert({
    id: uuidv4(),
    id_creator: id,
    title: title,
    adress: adress,
    description: description,
    date: new Date(date),
    lat: lat,
    long: long,
    token : randToken.generate(16)
  });
  if (!result) {
    return { error: "Error creating event" };
  }
  return result;
}

module.exports = {
  getEventUser,
  createEvent,
};
