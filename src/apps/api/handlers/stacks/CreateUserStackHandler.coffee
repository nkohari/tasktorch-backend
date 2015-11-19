Handler            = require 'apps/api/framework/Handler'
Stack              = require 'data/documents/Stack'
StackType          = require 'data/enums/StackType'
CreateStackCommand = require 'domain/commands/stacks/CreateStackCommand'

class CreateUserStackHandler extends Handler

  @route 'post /{orgid}/me/stacks'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name} = request.payload

    stack = new Stack {
      org:  org.id
      type: StackType.Backlog
      name: name
      user: user.id
    }

    command = new CreateStackCommand(user, stack)
    @processor.execute command, (err, stack) =>
      return reply err if err?
      return reply @response(stack)

module.exports = CreateUserStackHandler
