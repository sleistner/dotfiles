load(arguments[0]);

function readSTDIN() {
    var line,
        input = [],
        emptyCount = 0,
        i;

    line = readline();
    while (emptyCount < 25) {
        input.push(line);
        if (line) {
            emptyCount = 0;
        } else {
            emptyCount += 1;
        }
        line = readline();
    }

    input.splice(-emptyCount);
    return input.join("\n");
}

var body = arguments[2] || readSTDIN();
if (!JSLINT(body)) {
    var file = arguments[1], len = JSLINT.errors.length, error;
    for (var i = 0; i < len; i++) {
        error = JSLINT.errors[i];
        print(file + '(' + error.line + '): ' + error.id.replace(/\(|\)/g, '') + ': ' + error.reason.toLowerCase());
    }
}
