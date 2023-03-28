
function errorhandler(err, req, res, next) {
    console.log("errorhandler");
    let message = ""
    let errorCode = err.error || 500;
    switch (errorCode) {
        case 400:
            message = "Mauvaise requête";
            break;
        case 401:
            message = "Non autorisé";
            break;
        case 403:
            message = "Interdit";
            break;
        case 404:
            message = "Page non trouvée";
            break;
        case 405:
            message = "Methode non autorisée";
            break;
        case 500:
            message = "Erreur serveur";
            break;
        default:
            message = "Erreur inconnue";
            break;
    }
    res.setHeader("Content-Type", "application/json");
    res.status(errorCode).json({
        type: "error",
        error: errorCode,
        message: err.message ? err.message : message,
    });
}

module.exports ={
    errorhandler
}