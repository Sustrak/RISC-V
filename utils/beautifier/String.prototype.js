String.prototype.regexCount = function (pattern) {
    if (pattern.flags.indexOf("g") < 0) {
        pattern = new RegExp(pattern.source, pattern.flags + "g");
    }
    return (this.match(pattern) || []).length;
};
String.prototype.count = function (text) {
    return this.split(text).length - 1;
};
String.prototype.regexStartsWith = function (pattern) {
    var searchResult = this.search(pattern);
    return searchResult == 0;
};
String.prototype.regexIndexOf = function (pattern, startIndex) {
    startIndex = startIndex || 0;
    var searchResult = this.substr(startIndex).search(pattern);
    return (-1 === searchResult) ? -1 : searchResult + startIndex;
};
String.prototype.regexLastIndexOf = function (pattern, startIndex) {
    startIndex = startIndex === undefined ? this.length : startIndex;
    var searchResult = this.substr(0, startIndex).reverse().regexIndexOf(pattern, 0);
    return (-1 === searchResult) ? -1 : this.length - ++searchResult;
};
String.prototype.reverse = function () {
    return this.split('').reverse().join('');
};
String.prototype.convertToRegexBlockWords = function () {
    let result = new RegExp("(" + this + ")([^\\w]|$)");
    return result;
};
Array.prototype.convertToRegexBlockWords = function () {
    let wordsStr = this.join("|");
    let result = new RegExp("(" + wordsStr + ")([^\\w]|$)");
    return result;
};
