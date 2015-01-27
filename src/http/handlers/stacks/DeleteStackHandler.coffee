_                  = require 'lodash'
Handler            = require 'http/framework/Handler'
Response           = require 'http/framework/Response'
DeleteStackCommand = require 'domain/commands/stack/DeleteStackCommand'
StackType          = require 'domain/enums/StackType'

class DeleteStackHandler extends Handler

  @route 'delete /api/{orgId}/stacks/{stackId}'

  @prereqs {
    org:   'ResolveOrg'
    stack: 'ResolveStack'
  }

  constructor: (@processor) ->

  handle: (request, reply) ->

    requester = request.auth.credentials.user
    {org, stack} = request.pre

    # Ensure that the stack is part of the org.
    unless stack.org == org.id
      return reply @error.notFound()

    # Ensure that the requester is a member of the org.
    unless _.contains(org.members, requester.id)
      return reply @error.forbidden()

    # Ensure that the stack is not a special stack.
    unless stack.type == StackType.Backlog
      return reply @error.badRequest()

    # Ensure that the stack doesn't contain any cards.
    # TODO: Allow bulk movement of the cards to another stack.
    unless stack.cards.length == 0
      return reply @error.badRequest()

    command = new DeleteStackCommand(requester, stack)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.stack)

module.exports = DeleteStackHandler
