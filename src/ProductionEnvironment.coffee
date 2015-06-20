_               = require 'lodash'
loadFiles       = require 'common/util/loadFiles'
humanize        = require 'common/util/humanize'
Config          = require 'common/Config'
Log             = require 'common/Log'
Database        = require 'data/Database'
DatabaseWatcher = require 'data/DatabaseWatcher'
ConnectionPool  = require 'data/framework/ConnectionPool'
Processor       = require 'domain/Processor'
HttpServer      = require 'http/HttpServer'
ApiSite         = require 'http/sites/ApiSite'
AppSite         = require 'http/sites/AppSite'
PusherClient    = require 'messaging/PusherClient'
MessageBus      = require 'messaging/MessageBus'
Gatekeeper      = require 'security/Gatekeeper'
Keymaster       = require 'security/Keymaster'
PasswordHasher  = require 'security/PasswordHasher'

class ProductionEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('gatekeeper').to.type(Gatekeeper)
    forge.bind('keymaster').to.type(Keymaster)
    forge.bind('passwordHasher').to.type(PasswordHasher)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)
    forge.bind('databaseWatcher').to.type(DatabaseWatcher)
    forge.bind('processor').to.type(Processor)

    forge.bind('server').to.type(HttpServer)
    forge.bind('site').to.type(ApiSite)
    forge.bind('site').to.type(AppSite)

    forge.bind('pusher').to.type(PusherClient)
    forge.bind('messageBus').to.type(MessageBus)

    for name, type of loadFiles('http/handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)
      
    for name, type of loadFiles('http/preconditions', __dirname)
      forge.bind('precondition').to.type(type).when(humanize(name))

    for name, type of loadFiles('security/gates', __dirname)
      forge.bind('gate').to.type(type).when(name)

module.exports = ProductionEnvironment
