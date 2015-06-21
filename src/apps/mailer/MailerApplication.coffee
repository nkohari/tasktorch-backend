async             = require 'async'
Application       = require 'common/Application'
MailerEnvironment = require './MailerEnvironment'

class MailerApplication extends Application

  name: 'mailer'

  constructor: (environment = new MailerEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()
    listener = @forge.get('listener')
    listener.start()

module.exports = MailerApplication
