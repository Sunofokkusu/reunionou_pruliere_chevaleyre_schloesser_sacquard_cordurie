
function errorhandler(err, req, res, next) {
    let message = ""
    let errorCode = err.error || 500;
    switch (errorCode) {
        case 400:
            message = "Bad Request";
            break;
        case 401:
            message = "Unauthorized";
            break;
        case 403:
            message = "Forbidden";
            break;
        case 404:
            message = "Not Found";
            break;
        case 405:
            message = "Method Not Allowed";
            break;
        case 500:
            message = "Internal Server Error";
            break;
        default:
            message = "Internal Server Error";
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