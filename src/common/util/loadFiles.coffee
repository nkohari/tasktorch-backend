path = require 'path'
glob = require 'glob'
_    = require 'lodash'

module.exports = loadFiles = (dir, baseDir) ->
  files = glob.sync("#{dir}/**/*.coffee", {cwd: baseDir})
  return _.object _.map files, (file) ->
    name = path.basename(file, '.coffee')
    type = require path.resolve(baseDir, file)
    return [name, type]
