path                = require 'path'
_                   = require 'lodash'
ApiServer           = require 'apps/api/ApiServer'
loadFiles           = require 'common/util/loadFiles'
humanize            = require 'common/util/humanize'
AWSClientFactory    = require 'common/AWSClientFactory'
Config              = require 'common/Config'
JobQueue            = require 'common/JobQueue'
Log                 = require 'common/Log'
PusherClient        = require 'common/PusherClient'
StripeClientFactory = require 'common/StripeClientFactory'
Thumbnailer         = require 'common/Thumbnailer'
Database            = require 'data/Database'
ConnectionPool      = require 'data/framework/ConnectionPool'
Onboarder           = require 'data/framework/Onboarder'
CommandProcessor    = require 'domain/CommandProcessor'
EventSpool          = require 'domain/EventSpool'
Gatekeeper          = require 'security/Gatekeeper'
Keymaster           = require 'security/Keymaster'
PasswordHasher      = require 'security/PasswordHasher'

class ApiEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('gatekeeper').to.type(Gatekeeper)
    forge.bind('keymaster').to.type(Keymaster)
    forge.bind('passwordHasher').to.type(PasswordHasher)
    forge.bind('aws').to.type(AWSClientFactory)
    forge.bind('pusher').to.type(PusherClient)
    forge.bind('stripe').to.type(StripeClientFactory)
    forge.bind('thumbnailer').to.type(Thumbnailer)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)
    forge.bind('processor').to.type(CommandProcessor)
    forge.bind('jobQueue').to.type(JobQueue)
    forge.bind('spool').to.type(EventSpool)
    forge.bind('onboarder').to.type(Onboarder)
    forge.bind('server').to.type(ApiServer)

    for name, type of loadFiles('handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)
      
    for name, type of loadFiles('preconditions', __dirname)
      forge.bind('precondition').to.type(type).when(humanize(name))

    for name, type of loadFiles(path.resolve(__dirname, '../../security/gates'), __dirname)
      forge.bind('gate').to.type(type).when(name)

module.exports = ApiEnvironment
