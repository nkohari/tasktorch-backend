Handler             = require 'apps/api/framework/Handler'
DeleteActionCommand = require 'domain/commands/actions/DeleteActionCommand'

class DeleteActionHandler extends Handler

  @route 'delete /{orgid}/actions/{actionid}'

  @before [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester can access action'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {action} = request.pre
    {user}   = request.auth.credentials

    command = new DeleteActionCommand(user, action)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = DeleteActionHandler
