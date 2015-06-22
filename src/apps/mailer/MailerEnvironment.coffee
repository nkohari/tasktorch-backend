_                = require 'lodash'
AWSClientFactory = require 'common/AWSClientFactory'
Config           = require 'common/Config'
Log              = require 'common/Log'
JobListener      = require './JobListener'
JobProcessor     = require './JobProcessor'
Renderer         = require './Renderer'
Sender           = require './Sender'

class MailerEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('aws').to.type(AWSClientFactory)
    forge.bind('listener').to.type(JobListener)
    forge.bind('processor').to.type(JobProcessor)
    forge.bind('renderer').to.type(Renderer)
    forge.bind('sender').to.type(Sender)

module.exports = MailerEnvironment
