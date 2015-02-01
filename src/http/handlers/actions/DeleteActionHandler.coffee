Handler             = require 'http/framework/Handler'
DeleteActionCommand = require 'domain/commands/actions/DeleteActionCommand'

class DeleteActionHandler extends Handler

  @route 'delete /api/{orgid}/actions/{actionid}'

  @pre [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester can access action'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->
    {action} = request.pre
    command = new DeleteActionCommand(request.auth.credentials.user, action)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = DeleteActionHandler
