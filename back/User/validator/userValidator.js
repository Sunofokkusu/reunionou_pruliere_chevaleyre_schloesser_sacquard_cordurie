const joi = require('joi');

const userInsertSchema = joi.object({
    name: joi.string().min(3).max(30).required(),
    email: joi.string().email().required(),
    password: joi.string().min(6).max(30).required()
});

const userLoginSchema = joi.object({
    email: joi.string().email().required(),
    password: joi.string().min(6).max(30).required()
});

async function userInsertValidator(req, res, next) {
    const { error } = userInsertSchema.validate(req.body);
    if (error) {
        let wrongField = error.details[0].path[0];
        switch(wrongField) {
            case "name":
                next({ error: 400, message: "Veuillez entrez un nom entre 3 et 30 caractères" });
                break;
            case "email":
                next({ error: 400, message: "Veuillez entrez une adresse mail valide" });
                break;
            case "password":
                next({ error: 400, message: "Veuillez entrez un mot de passe entre 6 et 30 charactères" });
                break;
            default:
                next({ error: 400, message: "Veuillez entrez des informations valides" });
        }
    } else {
        next();
    }
}

async function userLoginValidator(req, res, next) {
    const { error } = userLoginSchema.validate(req.body);
    if (error) {
        next({ error: 400, message: "Email ou mot de passe incorrect" });
    } else {
        next();
    }
}

module.exports = {
    userInsertValidator,
    userLoginValidator
}