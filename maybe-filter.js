var fs = require('fs');
var Filter = require('broccoli-filter');
var symlinkOrCopySync = require('symlink-or-copy').sync

module.exports = MaybeFilter
MaybeFilter.prototype = Object.create(Filter.prototype)
MaybeFilter.prototype.constructor = MaybeFilter
function MaybeFilter (inputTree, options) {
  if (!inputTree) {
    throw new Error('broccoli-maybe-filter must be passed an inputTree, instead it received `undefined`');
  }

  Filter.call(this, inputTree, options);
}

MaybeFilter.prototype.processFile = function (srcDir, destDir, relativePath) {
  var self = this
  var inputEncoding = (this.inputEncoding === undefined) ? 'utf8' : this.inputEncoding
  var outputEncoding = (this.outputEncoding === undefined) ? 'utf8' : this.outputEncoding
  var string = fs.readFileSync(srcDir + '/' + relativePath, { encoding: inputEncoding })
  return Promise.resolve(self.processString(string, relativePath))
    .then(function (outputString) {
      if (outputString !== string) {
        var outputPath = self.getDestFilePath(relativePath)
        fs.writeFileSync(destDir + '/' + outputPath, outputString, { encoding: outputEncoding })
      } else {
        symlinkOrCopySync(srcDir + '/' + relativePath, destDir + '/' + relativePath)
      }
    })
}
