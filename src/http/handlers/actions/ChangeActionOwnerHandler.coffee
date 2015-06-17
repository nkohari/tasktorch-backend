Handler                  = require 'http/framework/Handler'
ChangeActionOwnerCommand = require 'domain/commands/actions/ChangeActionOwnerCommand'

class ChangeActionOwnerHandler extends Handler

  @route 'post /{orgid}/actions/{actionid}/user'

  @ensure
    payload:
      user: @mustBe.string().allow(null).required()

  @before [
    'resolve org'
    'resolve action'
    'resolve optional user argument'
    'ensure action belongs to org'
    'ensure requester can access action'
    'ensure user argument is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {action, user} = request.pre
    requester      = request.auth.credentials.user

    command = new ChangeActionOwnerCommand(requester, action, user)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionOwnerHandler
