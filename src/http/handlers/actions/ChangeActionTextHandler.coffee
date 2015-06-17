Handler                 = require 'http/framework/Handler'
ChangeActionTextCommand = require 'domain/commands/actions/ChangeActionTextCommand'

class ChangeActionTextHandler extends Handler

  @route 'post /{orgid}/actions/{actionid}/text'

  @ensure
    payload:
      text: @mustBe.string().allow(null, '').required()

  @before [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester can access action'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {action} = request.pre
    {text}   = request.payload
    {user}   = request.auth.credentials

    command = new ChangeActionTextCommand(user, action, text)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionTextHandler
