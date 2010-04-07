load(arguments[0]);

if (!JSLINT(arguments[2])) {
    var file = arguments[1], len = JSLINT.errors.length, error;
    for (var i = 0; i < len; i++) {
        error = JSLINT.errors[i];
        print(file + '(' + error.line + '): ' + error.id.replace(/\(|\)/g, '') + ': ' + error.reason.toLowerCase());
    }
}
