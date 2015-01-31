_               = require 'lodash'
loadFiles       = require 'common/util/loadFiles'
humanize        = require 'common/util/humanize'
Config          = require 'common/Config'
Log             = require 'common/Log'
Database        = require 'data/Database'
DatabaseWatcher = require 'data/DatabaseWatcher'
ConnectionPool  = require 'data/framework/ConnectionPool'
Processor       = require 'domain/Processor'
ApiServer       = require 'http/ApiServer'
PusherClient    = require 'messaging/PusherClient'
MessageBus      = require 'messaging/MessageBus'
SearchEngine    = require 'search/SearchEngine'
SearchIndexer   = require 'search/SearchIndexer'
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

    forge.bind('server').to.type(ApiServer)

    forge.bind('pusher').to.type(PusherClient)
    forge.bind('messageBus').to.type(MessageBus)

    forge.bind('searchEngine').to.type(SearchEngine)
    forge.bind('searchIndexer').to.type(SearchIndexer)

    for name, type of loadFiles('http/handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)
      
    for name, type of loadFiles('http/preconditions', __dirname)
      forge.bind('precondition').to.type(type).when(humanize(name))

    for name, type of loadFiles('search/factories', __dirname)
      forge.bind('searchModelFactory').to.type(type).when(name)

module.exports = ProductionEnvironment
