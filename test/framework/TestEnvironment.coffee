path            = require 'path'
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
Gatekeeper      = require 'security/Gatekeeper'
Keymaster       = require 'security/Keymaster'
PasswordHasher  = require 'security/PasswordHasher'

SRC_DIR = path.resolve(__dirname, '../../src')

class TestEnvironment

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

    for name, type of loadFiles('http/handlers', SRC_DIR)
      forge.bind('handler').to.type(type).when(name)
      
    for name, type of loadFiles('http/preconditions', SRC_DIR)
      forge.bind('precondition').to.type(type).when(humanize(name))

    for name, type of loadFiles('security/gates', SRC_DIR)
      forge.bind('gate').to.type(type).when(name)

module.exports = TestEnvironment
