Handler            = require 'http/framework/Handler'
Stack              = require 'domain/documents/Stack'
StackType          = require 'domain/enums/StackType'
CreateStackCommand = require 'domain/commands/stacks/CreateStackCommand'

class CreateUserStackHandler extends Handler

  @route 'post /api/{orgid}/me/stacks'

  @pre [
    'resolve org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name} = request.payload

    unless name?.length > 0
      return reply @error.badRequest("Missing required argument 'name'")

    stack = new Stack {
      org:  org.id
      type: StackType.Backlog
      name: name
      user: user.id
    }

    command = new CreateStackCommand(user, stack)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply @response(result.stack)

module.exports = CreateUserStackHandler
