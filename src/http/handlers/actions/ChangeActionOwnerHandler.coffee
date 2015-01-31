Handler                  = require 'http/framework/Handler'
ChangeActionOwnerCommand = require 'domain/commands/actions/ChangeActionOwnerCommand'

class ChangeActionOwnerHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/owner'

  @pre [
    'resolve org'
    'resolve action'
    'resolve user argument'
    'ensure action belongs to org'
    'ensure requester is member of org'
    'ensure user is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->
    {action, user} = request.pre
    command = new ChangeActionOwnerCommand(request.auth.credentials.user, action, user)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionOwnerHandler
