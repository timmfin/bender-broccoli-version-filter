PersistentFilter = require('broccoli-persistent-filter')
path = require('path')

utils = require('bender-broccoli-utils')

MaybeFilter = require('./maybe-filter')


class VersionFilter extends PersistentFilter
  description: 'VersionFilter'

  # Save the inner broccoli-filter cache to disk
  cacheByContent: true

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

    # @options.FilterConstructor ?= MaybeFilter

    super(inputTree, @options)
    { @benderContext } = @options

    throw new Error "No benderContext passed into VersionFilter options" unless @benderContext?

  processString: (str, relativePath) ->
    project = @benderContext.getProjectFromPath relativePath
    @benderContext.interpolateProjectVersionsIntoString project, str

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
