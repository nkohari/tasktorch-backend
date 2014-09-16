path      = require 'path'
glob      = require 'glob'
_         = require 'lodash'
Config    = require 'common/Config'
Log       = require 'common/Log'
ApiServer = require 'http/ApiServer'
routeMap  = require 'http/routes'

class ApiEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('routeMap').to.instance(routeMap)
    forge.bind('server').to.type(ApiServer)

    _.each @loadAllFiles('http/resources'), (type, name) ->
      forge.bind('resource').to.type(type).when(name)

  loadAllFiles: (dir) ->
    files = glob.sync("#{dir}/**/*.coffee", {cwd: __dirname})
    return _.object _.map files, (file) ->
      name = path.basename(file, '.coffee')
      type = require "./#{file}"
      return [name, type]

module.exports = ApiEnvironment
