(function() {
    load(arguments[0]);

    function readlines() {
        var line = readline(),
            input = [],
            emptyCount = 0;

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

    if (!JSLINT(readlines() || arguments[2])) {
        var file = arguments[1],
            len = JSLINT.errors.length,
            error,
            sillyReason = /expected an assignment or function call and instead saw an expression/i;

        for (var i = 0; i < len; i++) {
            error = JSLINT.errors[i];
            if (!sillyReason.test(error.reason)) {
                print(file + '(' + error.line + '): ' + error.id.replace(/\(|\)/g, '') + ': ' + error.reason.toLowerCase());
            }
        }
    }

}).apply(null, arguments);
