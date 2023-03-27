const express = require('express');
const app = express();

// Body parser
app.use(express.json());

app.use('/', require('./router/event'));

// error handler
const { errorhandler } = require('./handler/errorhandler');
app.use(errorhandler);

app.listen(process.env.PORT, () => {
    console.log(`Event service listening on port ${process.env.PORT}`);
});
