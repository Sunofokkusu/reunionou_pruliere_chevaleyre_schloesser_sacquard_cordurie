
function errorhandler(err, req, res, next) {
    let message = ""
    let errorCode = err.error || 500;
    switch (errorCode) {
        case 400:
            message = "Bad request";
            break;
        case 401:
            message = "Unauthorized";
            break;
        case 403:
            message = "Forbidden";
            break;
        case 404:
            message = "Not found";
            break;
        case 405:
            message = "Method not allowed";
            break;
        case 500:
            message = "Internal server error";
            break;
        default:
            message = "Internal server error";
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