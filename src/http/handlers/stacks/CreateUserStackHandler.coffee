async              = require 'async'
_                  = require 'lodash'
Handler            = require 'http/framework/Handler'
Response           = require 'http/framework/Response'
CreateStackCommand = require 'domain/commands/stack/CreateStackCommand'
Stack              = require 'domain/documents/Stack'
StackType          = require 'domain/enums/StackType'

class CreateUserStackHandler extends Handler

  @route 'post /api/{orgId}/me/stacks'

  @prereqs {
    org: 'ResolveOrg'
  }

  constructor: (@processor) ->

  handle: (request, reply) ->

    requester = request.auth.credentials.user
    {org} = request.pre

    # Ensure that the requester is a member of the org.
    unless _.contains(org.members, requester.id)
      return reply @error.forbidden()

    # Ensure that a name was specified for the stack.
    unless request.payload.name?.length > 0
      return reply @error.badRequest()

    stack = new Stack {
      org: org.id
      type:         StackType.Backlog
      name:         request.payload.name
      user:         requester.id
    }

    command = new CreateStackCommand(request.auth.credentials.user, stack)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.stack)

module.exports = CreateUserStackHandler
