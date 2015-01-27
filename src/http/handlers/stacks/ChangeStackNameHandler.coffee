_                      = require 'lodash'
Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'
ChangeStackNameCommand = require 'domain/commands/stack/ChangeStackNameCommand'

class ChangeStackNameHandler extends Handler

  @route 'post /api/{orgId}/stacks/{stackId}/name'

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

    # Ensure that a new name was specified for the stack.
    unless request.payload.name?.length > 0
      return reply @error.badRequest()

    command = new ChangeStackNameCommand(requester, stack, request.payload.name)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.stack)

module.exports = ChangeStackNameHandler
