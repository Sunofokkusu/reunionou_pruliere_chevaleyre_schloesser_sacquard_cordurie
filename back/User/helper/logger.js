const fs = require('fs');

function createFileLogger() {
    // si le dossier logs n'existe pas, on le crée
    if (!fs.existsSync('./logs')) {
        fs.mkdirSync('./logs');
    }
    // si le dossier logs n'existe pas, on le crée
    if (!fs.existsSync('./app.log')) {
        fs.mkdirSync('./app.log');
    }
}

function deleteLog() {
    // si le fichier à plus de 100 lignes, on enleve les 90 premières
    fs.readFile('./logs/app.log', 'utf8', (err, data) => {
        if (err) {
            console.log(err);
        } else {
            let lines = data.split('\r \n');
            if (lines.length > 100) {
                lines.splice(0, 90);
                fs.writeFile('./logs/app.log', lines.join('\r \n'), (err) => {
                    if (err) {
                        console.log(err);
                    }
                });
            }
        }
    });
}

async function info(message) {
    // on crée le fichier de log s'il n'existe pas
    createFileLogger();
    // on écrit le message dans le fichier de log
    fs.appendFile('./logs/app.log', `${new Date().toISOString()} - INFO - ${message} \r \n`, (err) => {
        if (err) {
            console.log(err);
        }
    });
    // deleteLog();
}

async function error(message) {
    // on crée le fichier de log s'il n'existe pas
    createFileLogger();
    // on écrit le message dans le fichier de log
    fs.appendFile('./logs/app.log', `${new Date().toISOString()} - ERROR - ${message} \r \n`, (err) => {
        if (err) {
            console.log(err);
        }
    });
    // deleteLog();
}

module.exports = {
    info,
    error
};