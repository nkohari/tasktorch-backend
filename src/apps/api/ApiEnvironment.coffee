path             = require 'path'
_                = require 'lodash'
ApiServer        = require 'apps/api/ApiServer'
loadFiles        = require 'common/util/loadFiles'
humanize         = require 'common/util/humanize'
Config           = require 'common/Config'
Log              = require 'common/Log'
PusherClient     = require 'common/PusherClient'
Database         = require 'data/Database'
ConnectionPool   = require 'data/framework/ConnectionPool'
Onboarder        = require 'data/framework/Onboarder'
CommandProcessor = require 'domain/CommandProcessor'
Gatekeeper       = require 'security/Gatekeeper'
Keymaster        = require 'security/Keymaster'
PasswordHasher   = require 'security/PasswordHasher'

class ApiEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('gatekeeper').to.type(Gatekeeper)
    forge.bind('keymaster').to.type(Keymaster)
    forge.bind('passwordHasher').to.type(PasswordHasher)
    forge.bind('pusher').to.type(PusherClient)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)
    forge.bind('processor').to.type(CommandProcessor)
    forge.bind('onboarder').to.type(Onboarder)
    forge.bind('server').to.type(ApiServer)

    for name, type of loadFiles('handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)
      
    for name, type of loadFiles('preconditions', __dirname)
      forge.bind('precondition').to.type(type).when(humanize(name))

    for name, type of loadFiles(path.resolve(__dirname, '../../security/gates'), __dirname)
      forge.bind('gate').to.type(type).when(name)

module.exports = ApiEnvironment
