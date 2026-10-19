// http-proxy-middleware only calls micromatch(list, patterns) to filter
// paths against glob contexts; picomatch covers that without pulling in braces.
const picomatch = require('picomatch');

function micromatch(list, patterns, options) {
    const isMatch = picomatch(patterns, options);
    return [].concat(list).filter((item) => isMatch(item));
}

micromatch.isMatch = (str, patterns, options) => picomatch(patterns, options)(str);

module.exports = micromatch;
