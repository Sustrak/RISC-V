class BeautifierSettings {
    constructor(removeComments, removeReport, checkAlias, signAlign, signAlignAll, keywordCase, indentation, newLineSettings) {
        this.RemoveComments = removeComments;
        this.RemoveAsserts = removeReport;
        this.CheckAlias = checkAlias;
        this.SignAlignRegional = signAlign;
        this.SignAlignAll = signAlignAll;
        this.KeywordCase = keywordCase;
        this.Indentation = indentation;
        this.NewLineSettings = newLineSettings;
    }
}
module.exports = BeautifierSettings;
