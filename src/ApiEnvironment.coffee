path           = require 'path'
glob           = require 'glob'
_              = require 'lodash'
Config         = require 'common/Config'
Log            = require 'common/Log'
PasswordHasher = require 'common/PasswordHasher'
PusherClient   = require 'common/PusherClient'
Database       = require 'data/Database'
ConnectionPool = require 'data/ConnectionPool'
EventBus       = require 'data/EventBus'
ApiServer      = require 'http/ApiServer'
Authenticator  = require 'http/Authenticator'

class ApiEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)
    forge.bind('passwordHasher').to.type(PasswordHasher)
    forge.bind('pusher').to.type(PusherClient)
    forge.bind('eventBus').to.type(EventBus)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)

    forge.bind('server').to.type(ApiServer)
    forge.bind('authenticator').to.type(Authenticator)

    for name, type of @loadAllFiles('data/schemas')
      forge.bind('schema').to.type(type).when(name)

    for name, type of @loadAllFiles('http/handlers')
      forge.bind('handler').to.type(type).when(name)

    for name, type of @loadAllFiles('http/demands')
      name = @humanize name.replace('Demand', '')
      forge.bind('demand').to.type(type).when(name)

  loadAllFiles: (dir) ->
    files = glob.sync("#{dir}/**/*.coffee", {cwd: __dirname})
    return _.object _.map files, (file) ->
      name = path.basename(file, '.coffee')
      type = require "./#{file}"
      return [name, type]

  humanize: (str) ->
    str.replace(/([A-Z])/g, ' $1').substr(1).toLowerCase()

module.exports = ApiEnvironment
