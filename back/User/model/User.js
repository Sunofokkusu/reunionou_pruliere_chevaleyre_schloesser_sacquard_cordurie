const db = require('../db/dbConnexion');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require("uuid");

async function signup(name, mail, password) {
    const user = await db('users').where({ email: mail }).first();
    if (user) {
        return { error: 'Utilisateur déjà existant' };
    }
    const hash = await bcrypt.hash(password, 10);
    const newUser = await db('users').insert({ id: uuidv4(), name: name, email: mail, pass: hash });
    if (!newUser) {
        return { error: 'Erreur lors de la création de l\'utilisateur' };
    }
    const token = jwt.sign({ id: newUser[0], name: name, email: mail }, process.env.JWT_SECRET, { expiresIn: '1h' });
    return { token };
}

async function login(mail, password) {
    const user = await db('users').where({ email: mail }).first();
    if (!user) {
        return { error: 'Email ou mot de passe incorrect' };
    }
    const match = await bcrypt.compare(password, user.pass);
    if (!match) {
        return { error: 'Email ou mot de passe incorrect' };
    }
    const token = jwt.sign({ id: user.id, name: user.name, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
    return { token };
}

async function validate(token) {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await db('users').where({ id: decoded.id }).first();
        if (!user) {
            return { error: 'token invalide' };
        }
        return { id: user.id, name: user.name, email: user.email };
    } catch (err) {
        return { error: 'token invalide' };
    }
}


module.exports = {
    signup,
    login,
    validate
}