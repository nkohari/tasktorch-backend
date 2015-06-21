path           = require 'path'
_              = require 'lodash'
loadFiles      = require 'common/util/loadFiles'
Watcher        = require 'apps/watcher/Watcher'
MessageBus     = require 'apps/watcher/messaging/MessageBus'
Config         = require 'common/Config'
Log            = require 'common/Log'
PusherClient   = require 'common/PusherClient'
Database       = require 'data/Database'
ConnectionPool = require 'data/framework/ConnectionPool'
Gatekeeper     = require 'security/Gatekeeper'

class WatcherEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)
    forge.bind('gatekeeper').to.type(Gatekeeper)
    forge.bind('pusher').to.type(PusherClient)
    forge.bind('messageBus').to.type(MessageBus)
    forge.bind('watcher').to.type(Watcher)

    for name, type of loadFiles('security/gates', path.resolve(__dirname, '../..'))
      forge.bind('gate').to.type(type).when(name)

module.exports = WatcherEnvironment
