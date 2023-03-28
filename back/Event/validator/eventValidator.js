const joi = require('joi');

const eventInsertSchema = joi.object({
    id : joi.uuid().required(),
    title : joi.string().min(3).max(30).required(),
    adress : joi.string().min(3).max(30).required(),
    description : joi.string().min(3).max(30),
    date : joi.string().required(),
    lat : joi.number().required(),
    long : joi.number().required(),
});

async function eventInsertValidator(req, res, next) {
    const { error } = eventInsertSchema.validate(req.body);
    if (error) {
        next({ error: 400, message: error.details[0].message });
    } else {
        next();
    }
}

module.exports = {
    eventInsertValidator
}

