Handler                 = require 'http/framework/Handler'
ChangeActionTextCommand = require 'domain/commands/actions/ChangeActionTextCommand'

class ChangeActionTextHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/text'

  @validate
    payload:
      text: @mustBe.string().allow(null, '').required()

  @pre [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester can access action'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {action} = request.pre
    {text}   = request.payload

    command = new ChangeActionTextCommand(request.auth.credentials.user, action, text)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionTextHandler
