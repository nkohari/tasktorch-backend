_                     = require 'lodash'
AWSClientFactory      = require 'common/AWSClientFactory'
Config                = require 'common/Config'
IntercomClientFactory = require 'common/IntercomClientFactory'
StripeClientFactory   = require 'common/StripeClientFactory'
JobQueue              = require 'common/JobQueue'
Log                   = require 'common/Log'
loadFiles             = require 'common/util/loadFiles'
EmailRenderer         = require 'common/email/EmailRenderer'
EmailSender           = require 'common/email/EmailSender'
Database              = require 'data/Database'
ConnectionPool        = require 'data/framework/ConnectionPool'
CommandProcessor      = require 'domain/CommandProcessor'
JobListener           = require './JobListener'
JobProcessor          = require './JobProcessor'

class WorkerEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('aws').to.type(AWSClientFactory)
    forge.bind('jobListener').to.type(JobListener)
    forge.bind('jobProcessor').to.type(JobProcessor)
    forge.bind('jobQueue').to.type(JobQueue)
    forge.bind('intercom').to.type(IntercomClientFactory)
    forge.bind('stripe').to.type(StripeClientFactory)

    forge.bind('connectionPool').to.type(ConnectionPool)
    forge.bind('database').to.type(Database)
    forge.bind('processor').to.type(CommandProcessor)

    forge.bind('emailRenderer').to.type(EmailRenderer)
    forge.bind('emailSender').to.type(EmailSender)

    for name, type of loadFiles('handlers', __dirname)
      forge.bind('handler').to.type(type).when(name)    

module.exports = WorkerEnvironment
