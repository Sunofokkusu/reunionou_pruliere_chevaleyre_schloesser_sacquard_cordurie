const joi = require('joi');

const userInsertSchema = joi.object({
    name: joi.string().min(3).max(30).required(),
    email: joi.string().email().required(),
    password: joi.string().min(6).max(30).required()
});

async function userInsertValidator(req, res, next) {
    const { error } = userInsertSchema.validate(req.body);
    if (error) {
        next({ error: 400, message: error.details[0].message });
    } else {
        next();
    }
}

module.exports = {
    userInsertValidator
}