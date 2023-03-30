const joi = require("joi");

const eventInsertSchema = joi.object({
  id: joi.string().required(),
  title: joi.string().min(3).max(30).required(),
  adress: joi.string().min(3).max(100).required(),
  description: joi.string().allow("").max(200),
  date: joi.string().required(),
  lat: joi.number().required(),
  long: joi.number().required(),
});

const participantInsertSchema = joi.object({
  name: joi.string().min(3).max(30).required(),
  id: joi.string(),
  status: joi.number().valid(0, 1, 2).required(),
  message: joi.string().allow("").max(200),
});

const commentInsertSchema = joi.object({
  name: joi.string().min(3).max(30).required(),
  id: joi.string(),
  message: joi.string().max(200).required(),
});

async function eventInsertValidator(req, res, next) {
  const { error } = eventInsertSchema.validate(req.body);
  if (error) {
    next({ error: 400, message: error.details[0].message });
  } else {
    next();
  }
}

async function participantInsertValidator(req, res, next) {
  const { error } = participantInsertSchema.validate(req.body);
  if (error) {
    next({ error: 400, message: error.details[0].message });
  } else {
    next();
  }
}

async function commentInsertValidator(req, res, next) {
  const { error } = commentInsertSchema.validate(req.body);
  if (error) {
    next({ error: 400, message: error.details[0].message });
  } else {
    next();
  }
}

module.exports = {
  eventInsertValidator,
  participantInsertValidator,
  commentInsertValidator,
};
