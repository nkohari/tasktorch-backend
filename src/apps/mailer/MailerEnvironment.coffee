_         = require 'lodash'
Config    = require 'common/Config'
Log       = require 'common/Log'
Listener  = require './Listener'
Processor = require './Processor'
Renderer  = require './Renderer'
Sender    = require './Sender'

class MailerEnvironment

  setup: (app, forge) ->

    forge.bind('app').to.instance(app)
    forge.bind('config').to.type(Config)
    forge.bind('log').to.type(Log)

    forge.bind('listener').to.type(Listener)
    forge.bind('processor').to.type(Processor)
    forge.bind('renderer').to.type(Renderer)
    forge.bind('sender').to.type(Sender)

module.exports = MailerEnvironment
