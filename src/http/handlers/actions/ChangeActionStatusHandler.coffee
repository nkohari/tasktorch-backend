Handler                   = require 'http/framework/Handler'
ChangeActionStatusCommand = require 'domain/commands/actions/ChangeActionStatusCommand'
ActionStatus              = require 'data/enums/ActionStatus'

class ChangeActionStatusHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/status'

  @pre [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {action} = request.pre
    {status} = request.payload

    unless status?.length > 0 and ActionStatus[status]?
      return reply @error.badRequest("Couldn't understand action status #{status}")

    command = new ChangeActionStatusCommand(request.auth.credentials.user, action, status)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionStatusHandler
