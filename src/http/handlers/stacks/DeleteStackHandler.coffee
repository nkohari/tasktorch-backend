Handler            = require 'http/framework/Handler'
StackType          = require 'data/enums/StackType'
DeleteStackCommand = require 'domain/commands/stacks/DeleteStackCommand'

class DeleteStackHandler extends Handler

  @route 'delete /api/{orgid}/stacks/{stackid}'

  @before [
    'resolve org'
    'resolve stack'
    'ensure stack belongs to org'
    'ensure requester can access stack'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stack} = request.pre
    {user}       = request.auth.credentials

    unless stack.type == StackType.Backlog
      return reply @error.badRequest("Stacks with type #{stack.type} cannot be deleted")

    # TODO: Allow bulk movement of the cards to another stack.
    unless stack.cards.length == 0
      return reply @error.badRequest("Stacks containing cards cannot be deleted")

    command = new DeleteStackCommand(user, stack)
    @processor.execute command, (err, stack) =>
      return reply err if err?
      return reply @response(stack)

module.exports = DeleteStackHandler
