Filter = require('broccoli-filter')
path = require('path')

utils = require('bender-broccoli-utils')


class VersionFilter extends Filter

  # Default extensions to insert versions into
  extensions: [
    'js'
    'coffee'

    'css'
    'sass'
    'scss'

    'html'
    'jade'
    'handlebars'

    'yaml'
    'lyaml'
  ]

  constructor: (@inputTree, @options = {}) ->
    if !(this instanceof VersionFilter)
      return new VersionFilter(inputTree, options)

    { @benderContext } = @options

    throw new Error "No benderContext passed into VersionFilter options" unless @benderContext?

  processString: (str, relativePath) ->
    project = @benderContext.getProject utils.extractProjectFromPath(relativePath)
    project.interpolateVersionsIntoString str

  canProcessFile: (relativePath) ->
    # Don't need to interpolate folders copied out of the archive (that already
    # have a version number in them)

    if utils.containsHardcodedStaticVersionInPath  relativePath
      false
    else
      super relativePath

  _extractBaseDirectory: (filepath) ->
    dirs = filepath.split(path.sep).filter (f) ->
      f? and f isnt ''

    dirs[0]



module.exports = VersionFilter