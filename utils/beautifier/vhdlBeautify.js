"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
let isTesting = false;
const ILCommentPrefix = "@@comments";
const ILQuotesPrefix = "@@quotes";
const ILSingleQuotesPrefix = "@@singlequotes";
/* MYCODE */
require("./String.prototype.js");
var Variables = require("./Variables.js");
var KeyWords = Variables.KeyWords;
var TypeNames = Variables.TypeNames;
let NewLineSettings = require("./NewLineSettings.js");
let BeautifierSettings = require("./BeautifierSettings.js");
let FormattedLine = require("./FormattedLine.js");
let fs = require('fs');
process.argv.splice(0, 2);
let fileName = process.argv.join(' ');
let input = fs.readFileSync(fileName, 'utf8');

var remove_comments = false;
var remove_lines = false;
var remove_report = false;
var check_alias = false;
var sign_align_port = false;
var sign_align_function = false;
var sign_align_procedure = false;
var sign_align_generic = false;
var sign_align_all = true;
var new_line_after_port = "NoNewLine";
var new_line_after_then = "NewLine";
var new_line_after_semicolon = "NewLine";
var new_line_after_else = "NewLine";
var new_line_after_generic = "None";
var use_space = false;
var compress = false;
var cust_indent = "";
var keywordcase = "LowerCase";
var mix_letter = false;

if (compress) {
    remove_comments = true;
}

let indentation = "\t";
if (use_space) {
    cust_indent = cust_indent.replace(/\\t/, "	");
    indentation = cust_indent;
}

var newLineSettingsDict = {};
newLineSettingsDict["generic"] = new_line_after_generic;
newLineSettingsDict["generic map"] = new_line_after_generic;
newLineSettingsDict["port"] = new_line_after_port;
newLineSettingsDict["port map"] = new_line_after_port;
newLineSettingsDict[";"] = new_line_after_semicolon;
newLineSettingsDict["then"] = new_line_after_then;
newLineSettingsDict["else"] = new_line_after_else;
var newLineSettings = ConstructNewLineSettings(newLineSettingsDict);

var signAlignKeywords = [];
if (sign_align_function) {
    signAlignKeywords.push("FUNCTION");
    signAlignKeywords.push("IMPURE FUNCTION");
}
if (sign_align_generic) {
    signAlignKeywords.push("GENERIC");
}
if (sign_align_port) {
    signAlignKeywords.push("PORT");
}
if (sign_align_procedure) {
    signAlignKeywords.push("PROCEDURE");
}
var sign_align = signAlignKeywords.length > 0;

var beautifierSettings = new BeautifierSettings(remove_comments, remove_report, check_alias, sign_align,
    sign_align_all,
    keywordcase, indentation, newLineSettings);
beautifierSettings.SignAlignKeyWords = signAlignKeywords;

input = beautify(input, beautifierSettings);
console.log(input);
fs.writeFileSync(fileName, input);
/* END MYCODE */
var FormatMode ={ '0': 'Default',
  '1': 'EndsWithSemicolon',
  '2': 'CaseWhen',
  '3': 'IfElse',
  '4': 'PortGeneric',
  Default: 0,
  EndsWithSemicolon: 1,
  CaseWhen: 2,
  IfElse: 3,
  PortGeneric: 4 };
var Mode = FormatMode.Default;
function ConstructNewLineSettings(dict) {
    let settings = new NewLineSettings();
    for (let key in dict) {
        settings.push(key, dict[key]);
    }
    return settings;
}
function fetchHeader(url, wch) {
    try {
        var req = new XMLHttpRequest();
        req.open("HEAD", url, false);
        req.send(null);
        if (req.status == 200) {
            return req.getResponseHeader(wch);
        }
        else
            return false;
    }
    catch (e) {
        return "";
    }
}
function wordWrap() {
    var d = document.getElementById("result");
    if (d.className == "") {
        d.className = "wordwrap";
    }
    else {
        d.className = "";
    }
}
function getHTMLInputElement(id) {
    return document.getElementById(id);
}
function noFormat() {
    let elements = [
        "remove_comments",
        "remove_lines",
        "remove_report",
        "check_alias",
        "sign_align_in",
        "sign_align_port",
        "sign_align_generic",
        "sign_align_function",
        "sign_align_procedure",
        "sign_align_all",
        "new_line_after",
        "use_space",
        "customise_indentation",
        "compress",
        "mix_letter"
    ];
    var isDisabled = getHTMLInputElement("no_format").checked;
    elements.forEach(element => {
        var htmlElement = getHTMLInputElement(element + "_div");
        try {
            getHTMLInputElement(element).disabled = isDisabled;
        }
        catch (_a) { }
        if (isDisabled) {
            htmlElement.className += " disabled";
        }
        else {
            htmlElement.className = htmlElement.className.replace(/\bdisabled\b/g, "");
        }
    });
    let radioButtons = document.getElementsByTagName("input");
    for (let i = 0; i < radioButtons.length; i++) {
        if (radioButtons[i].type == "radio") {
            radioButtons[i].disabled = isDisabled;
        }
    }
    getHTMLInputElement("cust_indent").disabled = isDisabled;
}
function indent_decode() {
    var custom_indent = getHTMLInputElement("cust_indent").value;
    var result = indentDecode(custom_indent);
    document.getElementById("indent_s").innerHTML = result;
}
function indentDecode(input) {
    input = input.replace(/\\t/g, "	");
    var count = [" & one ", " & two ", " & three ", " & four ", " & five ", " & six ", " & seven ", " & eight ", " & many "];
    var tokens = input.split("");
    var result = "";
    var repeatedCharCount = 0;
    for (var i = 0; i < tokens.length; i++) {
        var char = input.substr(i, 1);
        if (char == input.substr(i + 1, 1)) {
            repeatedCharCount++;
        }
        else {
            switch (char) {
                case " ":
                    char = "blankspace";
                    break;
                case "\t":
                    char = "tab";
                    break;
                default:
                    char = "'" + char + "'";
            }
            repeatedCharCount = repeatedCharCount > 8 ? 8 : repeatedCharCount;
            if (repeatedCharCount > 0) {
                char += "s";
            }
            result += count[repeatedCharCount] + char;
            repeatedCharCount = 0;
        }
    }
    if (result.length < 0) {
        switch (char) {
            case " ":
                char = "blankspace";
                break;
            case "\t":
                char = "tab";
        }
        repeatedCharCount = repeatedCharCount > 8 ? 8 : repeatedCharCount;
        result = count[repeatedCharCount] + char;
    }
    result = result.replace(/^ & /, "");
    return result;
}
exports.indentDecode = indentDecode;
function Compress(input) {
    input = input.replace(/\r\n/g, '');
    input = input.replace(/[\t ]+/g, ' ');
    input = input.replace(/[ ]?([&=:\-<>\+|])[ ]?/g, '$1');
    return input;
}
function MixLetters(input) {
    let arr = input.split("");
    for (var k = 0; k < arr.length; k++) {
        if (arr[k] === arr[k].toUpperCase() && Math.random() > 0.5) {
            arr[k] = arr[k].toLowerCase();
        }
        else if (Math.random() > 0.5) {
            arr[k] = arr[k].toUpperCase();
        }
    }
    return arr.join("");
}
function EscapeComments(arr, comments, commentIndex) {
    for (var i = 0; i < arr.length; i++) {
        let line = arr[i];
        var firstCharIndex = line.regexIndexOf(/[a-zA-Z0-9\(\&\)%_\+'"|\\]/);
        var commentStartIndex = line.indexOf("--");
        if (firstCharIndex < commentStartIndex && firstCharIndex >= 0) {
            comments.push(line.substr(commentStartIndex));
            arr[i] = line.substr(firstCharIndex, commentStartIndex - firstCharIndex) + ILCommentPrefix + (commentIndex++);
        }
        else if ((firstCharIndex > commentStartIndex && commentStartIndex >= 0) || (firstCharIndex < 0 && commentStartIndex >= 0)) {
            comments.push(line.substr(commentStartIndex));
            arr[i] = ILCommentPrefix + (commentIndex++);
        }
        else {
            firstCharIndex = firstCharIndex < 0 ? 0 : firstCharIndex;
            arr[i] = line.substr(firstCharIndex);
        }
    }
    return commentIndex;
}
function ToLowerCases(arr) {
    for (var i = 0; i < arr.length; i++) {
        arr[i] = arr[i].toLowerCase();
    }
}
function ToUpperCases(arr) {
    for (var i = 0; i < arr.length; i++) {
        arr[i] = arr[i].toUpperCase();
    }
}
function ToCamelCases(arr) {
    for (var i = 0; i < arr.length; i++) {
        arr[i] = arr[i].charAt(0) + arr[i].slice(1).toLowerCase();
    }
}
function ReplaceKeyWords(text, keywords) {
    for (var k = 0; k < keywords.length; k++) {
        text = text.replace(new RegExp("([^a-zA-Z0-9_@]|^)" + keywords[k] + "([^a-zA-Z0-9_]|$)", 'gi'), "$1" + keywords[k] + "$2");
    }
    return text;
}
function SetKeywordCase(input, keywordcase, keywords, typenames) {
    let inputcase = keywordcase.toLowerCase();
    switch (keywordcase.toLowerCase()) {
        case "lowercase":
            ToLowerCases(keywords);
            ToLowerCases(typenames);
            break;
        case "defaultcase":
            ToCamelCases(keywords);
            ToCamelCases(typenames);
            break;
        case "uppercase":
            ToUpperCases(keywords);
            ToUpperCases(typenames);
    }
    input = ReplaceKeyWords(input, keywords);
    input = ReplaceKeyWords(input, typenames);
    return input;
}
function SetNewLinesAfterSymbols(text, newLineSettings) {
    if (newLineSettings == null) {
        return text;
    }
    if (newLineSettings.newLineAfter != null) {
        newLineSettings.newLineAfter.forEach(symbol => {
            let regex = new RegExp("(" + symbol.toUpperCase() + ")[ ]?([^ \r\n@])", "g");
            text = text.replace(regex, '$1\r\n$2');
            if (symbol.toUpperCase() == "PORT") {
                text = text.replace(/PORT\s+MAP/, "PORT MAP");
            }
        });
    }
    if (newLineSettings.noNewLineAfter != null) {
        newLineSettings.noNewLineAfter.forEach(symbol => {
            let regex = new RegExp("(" + symbol.toUpperCase() + ")[ \r\n]+([^@])", "g");
            text = text.replace(regex, '$1 $2');
        });
    }
    return text;
}
exports.SetNewLinesAfterSymbols = SetNewLinesAfterSymbols;
function beautify(input, settings) {
    input = input.replace(/\r\n/g, "\n");
    input = input.replace(/\n/g, "\r\n");
    var arr = input.split("\r\n");
    var comments = [], commentsIndex = 0;
    commentsIndex = EscapeComments(arr, comments, commentsIndex);
    input = arr.join("\r\n");
    if (settings.RemoveComments) {
        input = input.replace(/\r\n[ \t]*@@comments[0-9]+[ \t]*\r\n/g, '\r\n');
        input = input.replace(/@@comments[0-9]+/g, '');
        commentsIndex = 0;
    }
    input = RemoveExtraNewLines(input);
    input = input.replace(/[\t ]+/g, ' ');
    input = input.replace(/\([\t ]+/g, '\(');
    input = input.replace(/[ ]+;/g, ';');
    input = input.replace(/:[ ]*(PROCESS|ENTITY)/gi, ':$1');
    arr = input.split("\r\n");
    let quotes = EscapeQuotes(arr);
    let singleQuotes = EscapeSingleQuotes(arr);
    input = arr.join("\r\n");
    input = SetKeywordCase(input, "uppercase", KeyWords, TypeNames);
    arr = input.split("\r\n");
    if (settings.RemoveAsserts) {
        RemoveAsserts(arr); //RemoveAsserts must be after EscapeQuotes
    }
    ReserveSemicolonInKeywords(arr);
    input = arr.join("\r\n");
    input = input.replace(/(PORT|GENERIC)\s+MAP/g, '$1 MAP');
    input = input.replace(/(PORT|PROCESS|GENERIC)[\s]*\(/g, '$1 (');
    input = SetNewLinesAfterSymbols(input, settings.NewLineSettings);
    arr = input.split("\r\n");
    ApplyNoNewLineAfter(arr, settings.NewLineSettings.noNewLineAfter);
    input = arr.join("\r\n");
    //new
    input = input.replace(/([a-zA-Z0-9\); ])\);(@@comments[0-9]+)?@@end/g, '$1\r\n);$2@@end');
    input = input.replace(/[ ]?([&=:\-<>\+|\*])[ ]?/g, ' $1 ');
    input = input.replace(/[ ]?([,])[ ]?/g, '$1 ');
    input = input.replace(/[ ]?(['"])(THEN)/g, '$1 $2');
    input = input.replace(/[ ]?(\?)?[ ]?(<|:|>|\/)?[ ]+(=)?[ ]?/g, ' $1$2$3 ');
    input = input.replace(/(IF)[ ]?([\(\)])/g, '$1 $2');
    input = input.replace(/([\(\)])[ ]?(THEN)/gi, '$1 $2');
    input = input.replace(/(^|[\(\)])[ ]?(AND|OR|XOR|XNOR)[ ]*([\(])/g, '$1 $2 $3');
    input = input.replace(/ ([\-\*\/=+<>])[ ]*([\-\*\/=+<>]) /g, " $1$2 ");
    //input = input.replace(/\r\n[ \t]+--\r\n/g, "\r\n");
    input = input.replace(/[ ]+/g, ' ');
    input = input.replace(/[ \t]+\r\n/g, "\r\n");
    input = input.replace(/\r\n\r\n\r\n/g, '\r\n');
    input = input.replace(/[\r\n\s]+$/g, '');
    input = input.replace(/[ \t]+\)/g, ')');
    input = input.replace(/\s*\)\s+RETURN\s+([\w]+;)/g, '\r\n) RETURN $1'); //function(..\r\n)return type; -> function(..\r\n)return type;
    arr = input.split("\r\n");
    let result = [];
    beautify3(arr, result, settings, 0, 0);
    if (settings.SignAlignAll) {
        AlignSigns(result, 0, result.length - 1);
    }
    arr = FormattedLineToString(result, settings.Indentation);
    input = arr.join("\r\n");
    input = SetKeywordCase(input, settings.KeywordCase, KeyWords, TypeNames);
    for (var k = 0; k < quotes.length; k++) {
        input = input.replace(ILQuotesPrefix + k, quotes[k]);
    }
    for (var k = 0; k < singleQuotes.length; k++) {
        input = input.replace(ILSingleQuotesPrefix + k, singleQuotes[k]);
    }
    for (var k = 0; k < commentsIndex; k++) {
        input = input.replace(ILCommentPrefix + k, comments[k]);
    }
    input = input.replace(/@@semicolon/g, ";");
    input = input.replace(/@@[a-z]+/g, "");
    return input;
}
exports.beautify = beautify;
function FormattedLineToString(arr, indentation) {
    let result = [];
    if (arr == null) {
        return result;
    }
    arr.forEach(i => {
        if (i instanceof FormattedLine) {
            if (i.Line.length > 0) {
                result.push((Array(i.Indent + 1).join(indentation)) + i.Line);
            }
            else {
                result.push("");
            }
        }
        else {
            result = result.concat(FormattedLineToString(i, indentation));
        }
    });
    return result;
}
exports.FormattedLineToString = FormattedLineToString;
function GetCloseparentheseEndIndex(inputs, startIndex) {
    let openParentheseCount = 0;
    let closeParentheseCount = 0;
    for (let i = startIndex; i < inputs.length; i++) {
        let input = inputs[i];
        openParentheseCount += input.count("(");
        closeParentheseCount += input.count(")");
        if (openParentheseCount > 0
            && openParentheseCount <= closeParentheseCount) {
            return i;
        }
    }
    return startIndex;
}
function beautifyPortGenericBlock(inputs, result, settings, startIndex, parentEndIndex, indent, mode) {
    let firstLine = inputs[startIndex];
    let regex = new RegExp("[\\w\\s:]*(" + mode + ")([\\s]|$)");
    if (!firstLine.regexStartsWith(regex)) {
        return [startIndex, parentEndIndex];
    }
    let firstLineHasParenthese = firstLine.indexOf("(") >= 0;
    let hasParenthese = firstLineHasParenthese;
    let blockBodyStartIndex = startIndex;
    let secondLineHasParenthese = startIndex + 1 < inputs.length && inputs[startIndex + 1].startsWith("(");
    if (secondLineHasParenthese) {
        hasParenthese = true;
        blockBodyStartIndex++;
    }
    let endIndex = hasParenthese ? GetCloseparentheseEndIndex(inputs, startIndex) : startIndex;
    if (endIndex != startIndex && firstLineHasParenthese) {
        inputs[startIndex] = inputs[startIndex].replace(/(PORT|GENERIC|PROCEDURE)([\w ]+)\(([\w\(\) ]+)/, '$1$2(\r\n$3');
        let newInputs = inputs[startIndex].split("\r\n");
        if (newInputs.length == 2) {
            inputs[startIndex] = newInputs[0];
            inputs.splice(startIndex + 1, 0, newInputs[1]);
            endIndex++;
            parentEndIndex++;
        }
    }
    else if (endIndex > startIndex + 1 && secondLineHasParenthese) {
        inputs[startIndex + 1] = inputs[startIndex + 1].replace(/\(([\w\(\) ]+)/, '(\r\n$1');
        let newInputs = inputs[startIndex + 1].split("\r\n");
        if (newInputs.length == 2) {
            inputs[startIndex + 1] = newInputs[0];
            inputs.splice(startIndex + 2, 0, newInputs[1]);
            endIndex++;
            parentEndIndex++;
        }
    }
    if (firstLineHasParenthese && inputs[startIndex].indexOf("MAP") > 0) {
        inputs[startIndex] = inputs[startIndex].replace(/([^\w])(MAP)\s+\(/g, '$1$2(');
    }
    result.push(new FormattedLine(inputs[startIndex], indent));
    if (secondLineHasParenthese) {
        let secondLineIndent = indent;
        if (endIndex == startIndex + 1) {
            secondLineIndent++;
        }
        result.push(new FormattedLine(inputs[startIndex + 1], secondLineIndent));
    }
    let blockBodyEndIndex = endIndex;
    let i = beautify3(inputs, result, settings, blockBodyStartIndex + 1, indent + 1, endIndex);
    if (inputs[i].startsWith(")")) {
        result[i].Indent--;
        blockBodyEndIndex--;
    }
    if (settings.SignAlignRegional && !settings.SignAlignAll
        && settings.SignAlignKeyWords != null
        && settings.SignAlignKeyWords.indexOf(mode) >= 0) {
        blockBodyStartIndex++;
        AlignSigns(result, blockBodyStartIndex, blockBodyEndIndex);
    }
    return [i, parentEndIndex];
}
exports.beautifyPortGenericBlock = beautifyPortGenericBlock;
function AlignSigns(result, startIndex, endIndex) {
    AlignSign_(result, startIndex, endIndex, ":");
    AlignSign_(result, startIndex, endIndex, ":=");
    AlignSign_(result, startIndex, endIndex, "=>");
    AlignSign_(result, startIndex, endIndex, "<=");
}
exports.AlignSigns = AlignSigns;
function AlignSign_(result, startIndex, endIndex, symbol) {
    let maxSymbolIndex = -1;
    let symbolIndices = {};
    let startLine = startIndex;
    let labelAndKeywords = [
        "([\\w\\s]*:(\\s)*PROCESS)",
        "([\\w\\s]*:(\\s)*POSTPONED PROCESS)",
        "([\\w\\s]*:\\s*$)",
        "([\\w\\s]*:.*\\s+GENERATE)"
    ];
    let labelAndKeywordsStr = labelAndKeywords.join("|");
    let labelAndKeywordsRegex = new RegExp("(" + labelAndKeywordsStr + ")([^\\w]|$)");
    for (let i = startIndex; i <= endIndex; i++) {
        let line = result[i].Line;
        if (symbol == ":" && line.regexStartsWith(labelAndKeywordsRegex)) {
            continue;
        }
        let regex = new RegExp("([\\s\\w\\\\]|^)" + symbol + "([\\s\\w\\\\]|$)");
        if (line.regexCount(regex) > 1) {
            continue;
        }
        let colonIndex = line.regexIndexOf(regex);
        if (colonIndex > 0) {
            maxSymbolIndex = Math.max(maxSymbolIndex, colonIndex);
            symbolIndices[i] = colonIndex;
        }
        else if (!line.startsWith(ILCommentPrefix) && line.length != 0) {
            if (startLine < i - 1) {
                AlignSign(result, startLine, i - 1, symbol, maxSymbolIndex, symbolIndices);
            }
            maxSymbolIndex = -1;
            symbolIndices = {};
            startLine = i;
        }
    }
    if (startLine < endIndex) {
        AlignSign(result, startLine, endIndex, symbol, maxSymbolIndex, symbolIndices);
    }
}
function AlignSign(result, startIndex, endIndex, symbol, maxSymbolIndex = -1, symbolIndices = {}) {
    if (maxSymbolIndex < 0) {
        return;
    }
    for (let lineIndex in symbolIndices) {
        let symbolIndex = symbolIndices[lineIndex];
        if (symbolIndex == maxSymbolIndex) {
            continue;
        }
        let line = result[lineIndex].Line;
        result[lineIndex].Line = line.substring(0, symbolIndex)
            + (Array(maxSymbolIndex - symbolIndex + 1).join(" "))
            + line.substring(symbolIndex);
    }
}
exports.AlignSign = AlignSign;
function beautifyCaseBlock(inputs, result, settings, startIndex, indent) {
    if (!inputs[startIndex].regexStartsWith(/(.+:\s*)?(CASE)([\s]|$)/)) {
        return startIndex;
    }
    result.push(new FormattedLine(inputs[startIndex], indent));
    let i = beautify3(inputs, result, settings, startIndex + 1, indent + 2);
    result[i].Indent = indent;
    return i;
}
exports.beautifyCaseBlock = beautifyCaseBlock;
function getSemicolonBlockEndIndex(inputs, settings, startIndex, parentEndIndex) {
    let endIndex = 0;
    let openBracketsCount = 0;
    let closeBracketsCount = 0;
    for (let i = startIndex; i < inputs.length; i++) {
        let input = inputs[i];
        let indexOfSemicolon = input.indexOf(";");
        let splitIndex = indexOfSemicolon < 0 ? input.length : indexOfSemicolon + 1;
        let stringBeforeSemicolon = input.substring(0, splitIndex);
        let stringAfterSemicolon = input.substring(splitIndex);
        stringAfterSemicolon = stringAfterSemicolon.replace(new RegExp(ILCommentPrefix + "[0-9]+"), "");
        openBracketsCount += stringBeforeSemicolon.count("(");
        closeBracketsCount += stringBeforeSemicolon.count(")");
        if (indexOfSemicolon < 0) {
            continue;
        }
        if (openBracketsCount == closeBracketsCount) {
            endIndex = i;
            if (stringAfterSemicolon.trim().length > 0 && settings.NewLineSettings.newLineAfter.indexOf(";") >= 0) {
                inputs[i] = stringBeforeSemicolon;
                inputs.splice(i, 0, stringAfterSemicolon);
                parentEndIndex++;
            }
            break;
        }
    }
    return [endIndex, parentEndIndex];
}
function beautifyComponentBlock(inputs, result, settings, startIndex, parentEndIndex, indent) {
    let endIndex = startIndex;
    for (let i = startIndex; i < inputs.length; i++) {
        if (inputs[i].regexStartsWith(/END(\s|$)/)) {
            endIndex = i;
            break;
        }
    }
    result.push(new FormattedLine(inputs[startIndex], indent));
    if (endIndex != startIndex) {
        let actualEndIndex = beautify3(inputs, result, settings, startIndex + 1, indent + 1, endIndex);
        let incremental = actualEndIndex - endIndex;
        endIndex += incremental;
        parentEndIndex += incremental;
    }
    return [endIndex, parentEndIndex];
}
exports.beautifyComponentBlock = beautifyComponentBlock;
function beautifySemicolonBlock(inputs, result, settings, startIndex, parentEndIndex, indent) {
    let endIndex = startIndex;
    [endIndex, parentEndIndex] = getSemicolonBlockEndIndex(inputs, settings, startIndex, parentEndIndex);
    result.push(new FormattedLine(inputs[startIndex], indent));
    if (endIndex != startIndex) {
        let i = beautify3(inputs, result, settings, startIndex + 1, indent + 1, endIndex);
    }
    return [endIndex, parentEndIndex];
}
exports.beautifySemicolonBlock = beautifySemicolonBlock;
function beautify3(inputs, result, settings, startIndex, indent, endIndex) {
    let i;
    let regexOneLineBlockKeyWords = new RegExp(/(PROCEDURE)[^\w](?!.+[^\w]IS([^\w]|$))/); //match PROCEDURE..; but not PROCEDURE .. IS;
    let regexFunctionMultiLineBlockKeyWords = new RegExp(/(FUNCTION|IMPURE FUNCTION)[^\w](?=.+[^\w]IS([^\w]|$))/); //match FUNCTION .. IS; but not FUNCTION
    let blockMidKeyWords = ["BEGIN"];
    let blockStartsKeyWords = [
        "IF",
        "CASE",
        "ARCHITECTURE",
        "PROCEDURE",
        "PACKAGE",
        "(([\\w\\s]*:)?(\\s)*PROCESS)",
        "(([\\w\\s]*:)?(\\s)*POSTPONED PROCESS)",
        "(.*\\s*PROTECTED)",
        "(COMPONENT)",
        "(ENTITY(?!.+;))",
        "FOR",
        "WHILE",
        "LOOP",
        "(.*\\s*GENERATE)",
        "(CONTEXT[\\w\\s\\\\]+IS)",
        "(CONFIGURATION(?!.+;))",
        "BLOCK",
        "UNITS",
        "\\w+\\s+\\w+\\s+IS\\s+RECORD"
    ];
    let blockEndsKeyWords = ["END", ".*\\)\\s*RETURN\\s+[\\w]+;"];
    let blockEndsWithSemicolon = [
        "(WITH\\s+[\\w\\s\\\\]+SELECT)",
        "([\\w\\\\]+[\\s]*<=)",
        "([\\w\\\\]+[\\s]*:=)",
        "FOR\\s+[\\w\\s,]+:\\s*\\w+\\s+USE",
        "REPORT"
    ];
    let newLineAfterKeyWordsStr = blockStartsKeyWords.join("|");
    let regexBlockMidKeyWords = blockMidKeyWords.convertToRegexBlockWords();
    let regexBlockStartsKeywords = new RegExp("([\\w]+\\s*:\\s*)?(" + newLineAfterKeyWordsStr + ")([^\\w]|$)");
    let regexBlockEndsKeyWords = blockEndsKeyWords.convertToRegexBlockWords();
    let regexblockEndsWithSemicolon = blockEndsWithSemicolon.convertToRegexBlockWords();
    let regexMidKeyWhen = "WHEN".convertToRegexBlockWords();
    let regexMidKeyElse = "ELSE|ELSIF".convertToRegexBlockWords();
    if (endIndex == null) {
        endIndex = inputs.length - 1;
    }
    for (i = startIndex; i <= endIndex; i++) {
        if (indent < 0) {
            indent = 0;
        }
        let input = inputs[i].trim();
        if (input.regexStartsWith(/COMPONENT\s/)) {
            let modeCache = Mode;
            Mode = 1;
            [i, endIndex] = beautifyComponentBlock(inputs, result, settings, i, endIndex, indent);
            Mode = modeCache;
            continue;
        }
        if (input.regexStartsWith(/\w+\s*:\s*ENTITY/)) {
            let modeCache = Mode;
            Mode = 1;
            [i, endIndex] = beautifySemicolonBlock(inputs, result, settings, i, endIndex, indent);
            Mode = modeCache;
            continue;
        }
        if (Mode != 1 && input.regexStartsWith(regexblockEndsWithSemicolon)) {
            let modeCache = Mode;
            Mode = 1;
            [i, endIndex] = beautifySemicolonBlock(inputs, result, settings, i, endIndex, indent);
            Mode = modeCache;
            continue;
        }
        if (input.regexStartsWith(/(.+:\s*)?(CASE)([\s]|$)/)) {
            let modeCache = Mode;
            Mode = 2;
            i = beautifyCaseBlock(inputs, result, settings, i, indent);
            Mode = modeCache;
            continue;
        }
        if (input.regexStartsWith(/[\w\s:]*PORT([\s]|$)/)) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "PORT");
            continue;
        }
        if (input.regexStartsWith(/TYPE\s+\w+\s+IS\s+\(/)) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "IS");
            continue;
        }
        if (input.regexStartsWith(/[\w\s:]*GENERIC([\s]|$)/)) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "GENERIC");
            continue;
        }
        if (input.regexStartsWith(/[\w\s:]*PROCEDURE[\s\w]+\($/)) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "PROCEDURE");
            if (inputs[i].regexStartsWith(/.*\)[\s]*IS/)) {
                i = beautify3(inputs, result, settings, i + 1, indent + 1);
            }
            continue;
        }
        if (input.regexStartsWith(/FUNCTION[^\w]/)
            && input.regexIndexOf(/[^\w]RETURN[^\w]/) < 0) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "FUNCTION");
            if (!inputs[i].regexStartsWith(regexBlockEndsKeyWords)) {
                i = beautify3(inputs, result, settings, i + 1, indent + 1);
            }
            else {
                result[i].Indent++;
            }
            continue;
        }
        if (input.regexStartsWith(/IMPURE FUNCTION[^\w]/)
            && input.regexIndexOf(/[^\w]RETURN[^\w]/) < 0) {
            [i, endIndex] = beautifyPortGenericBlock(inputs, result, settings, i, endIndex, indent, "IMPURE FUNCTION");
            if (!inputs[i].regexStartsWith(regexBlockEndsKeyWords)) {
                i = beautify3(inputs, result, settings, i + 1, indent + 1);
            }
            else {
                result[i].Indent++;
            }
            continue;
        }
        result.push(new FormattedLine(input, indent));
        if (startIndex != 0
            && (input.regexStartsWith(regexBlockMidKeyWords)
                || (Mode != 1 && input.regexStartsWith(regexMidKeyElse))
                || (Mode == 2 && input.regexStartsWith(regexMidKeyWhen)))) {
            result[i].Indent--;
        }
        else if (startIndex != 0
            && (input.regexStartsWith(regexBlockEndsKeyWords))) {
            result[i].Indent--;
            return i;
        }
        if (input.regexStartsWith(regexOneLineBlockKeyWords)) {
            continue;
        }
        if (input.regexStartsWith(regexFunctionMultiLineBlockKeyWords)
            || input.regexStartsWith(regexBlockStartsKeywords)) {
            i = beautify3(inputs, result, settings, i + 1, indent + 1);
        }
    }
    i--;
    return i;
}
exports.beautify3 = beautify3;
function ReserveSemicolonInKeywords(arr) {
    for (let i = 0; i < arr.length; i++) {
        if (arr[i].match(/FUNCTION|PROCEDURE/) != null) {
            arr[i] = arr[i].replace(/;/g, '@@semicolon');
        }
    }
}
function ApplyNoNewLineAfter(arr, noNewLineAfter) {
    if (noNewLineAfter == null) {
        return;
    }
    for (let i = 0; i < arr.length; i++) {
        noNewLineAfter.forEach(n => {
            let regex = new RegExp("(" + n.toUpperCase + ")[ a-z0-9]+[a-z0-9]+");
            if (arr[i].regexIndexOf(regex) >= 0) {
                arr[i] += "@@singleline";
            }
        });
    }
}
exports.ApplyNoNewLineAfter = ApplyNoNewLineAfter;
function RemoveAsserts(arr) {
    let need_semi = false;
    let inAssert = false;
    let n = 0;
    for (let i = 0; i < arr.length; i++) {
        let has_semi = arr[i].indexOf(";") >= 0;
        if (need_semi) {
            arr[i] = '';
        }
        n = arr[i].indexOf("ASSERT ");
        if (n >= 0) {
            inAssert = true;
            arr[i] = '';
        }
        if (!has_semi) {
            if (inAssert) {
                need_semi = true;
            }
        }
        else {
            need_semi = false;
        }
    }
}
exports.RemoveAsserts = RemoveAsserts;
function EscapeQuotes(arr) {
    let quotes = [];
    let quotesIndex = 0;
    for (let i = 0; i < arr.length; i++) {
        let quote = arr[i].match(/"([^"]+)"/g);
        if (quote != null) {
            for (var j = 0; j < quote.length; j++) {
                arr[i] = arr[i].replace(quote[j], ILQuotesPrefix + quotesIndex);
                quotes[quotesIndex++] = quote[j];
            }
        }
    }
    return quotes;
}
function EscapeSingleQuotes(arr) {
    let quotes = [];
    let quotesIndex = 0;
    for (let i = 0; i < arr.length; i++) {
        let quote = arr[i].match(/'[^']'/g);
        if (quote != null) {
            for (var j = 0; j < quote.length; j++) {
                arr[i] = arr[i].replace(quote[j], ILSingleQuotesPrefix + quotesIndex);
                quotes[quotesIndex++] = quote[j];
            }
        }
    }
    return quotes;
}
function RemoveExtraNewLines(input) {
    input = input.replace(/(?:\r\n|\r|\n)/g, '\r\n');
    input = input.replace(/ \r\n/g, '\r\n');
    input = input.replace(/\r\n\r\n\r\n/g, '\r\n');
    return input;
}
//# sourceMappingURL=VHDLFormatter.js.map
