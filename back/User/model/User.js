const db = require('../db/dbConnexion');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require("uuid");

async function signup(name, mail, password) {
    const user = await db('users').where({ email: mail }).first();
    if (user) {
        return { error: 'User already exists' };
    }
    const hash = await bcrypt.hash(password, 10);
    const newUser = await db('users').insert({ id: uuidv4(), name: name, email: mail, pass: hash });
    if (!newUser) {
        return { error: 'Error creating user' };
    }
    const token = jwt.sign({ id: newUser[0], name: name, email: mail }, process.env.JWT_SECRET, { expiresIn: '1h' });
    return { token };
}

module.exports = {
    signup
}