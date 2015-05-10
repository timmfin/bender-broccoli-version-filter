TieredCachingWriter = require('broccoli-tiered-caching-writer')
path = require('path')

utils = require('bender-broccoli-utils')

MaybeFilter = require('./maybe-filter')


class VersionFilter extends TieredCachingWriter

  # Default extensions to insert versions into
  extensions: [
    'js'
    'coffee'
    'cjsx'

    'css'
    'sass'
    'scss'

    'html'
    'jade'
    'handlebars'

    'yaml'
    'lyaml'
  ]

  constructor: (inputTree, @options = {}) ->
    if !(this instanceof VersionFilter)
      return new VersionFilter(inputTree, options)

    @options.FilterConstructor ?= MaybeFilter

    super(inputTree, @options)
    { @benderContext } = @options

    throw new Error "No benderContext passed into VersionFilter options" unless @benderContext?

  processString: (str, relativePath) ->
    project = @benderContext.getProjectFromPath relativePath
    project.interpolateVersionsIntoString str

  canProcessFile: (relativePath) ->
    # Don't need to interpolate folders copied out of the archive (that already
    # have a version number in them)

    if utils.containsHardcodedStaticVersionInPath relativePath
      false
    else
      super relativePath

  _extractBaseDirectory: (filepath) ->
    dirs = filepath.split(path.sep).filter (f) ->
      f? and f isnt ''

    dirs[0]



module.exports = VersionFilter
