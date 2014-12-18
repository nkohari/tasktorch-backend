_              = require 'lodash'
loadFiles      = require 'common/util/loadFiles'
Config         = require 'common/Config'
Log            = require 'common/Log'
PasswordHasher = require 'common/PasswordHasher'
Database       = require 'data/Database'
ConnectionPool = require 'data/ConnectionPool'
Processor      = require 'domain/Processor'
ApiServer      = require 'http/ApiServer'
Authenticator  = require 'http/Authenticator'
PusherClient   = require 'messaging/PusherClient'
MessageBus     = require 'messaging/MessageBus'
SearchEngine   = require 'search/SearchEngine'
SearchIndexer  = require 'search/SearchIndexer'

class ApiEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)
    forge.bind('passwordHasher').to.type(PasswordHasher)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)

    forge.bind('processor').to.type(Processor)

    forge.bind('server').to.type(ApiServer)
    forge.bind('authenticator').to.type(Authenticator)

    forge.bind('pusher').to.type(PusherClient)
    forge.bind('messageBus').to.type(MessageBus)

    forge.bind('searchEngine').to.type(SearchEngine)
    forge.bind('searchIndexer').to.type(SearchIndexer)

    for name, type of loadFiles('data/schemas', __dirname)
      forge.bind('schema').to.type(type).when(name)

    for name, type of loadFiles('http/handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)

    for name, type of loadFiles('http/demands', __dirname)
      name = @humanize name.replace('Demand', '')
      forge.bind('demand').to.type(type).when(name)

    for name, type of loadFiles('search/factories', __dirname)
      forge.bind('searchModelFactory').to.type(type).when(name)

  humanize: (str) ->
    str.replace(/([A-Z])/g, ' $1').substr(1).toLowerCase()

module.exports = ApiEnvironment
