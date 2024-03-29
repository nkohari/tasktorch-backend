Handler                = require 'apps/api/framework/Handler'
StackType              = require 'data/enums/StackType'
ChangeStackNameCommand = require 'domain/commands/stacks/ChangeStackNameCommand'

class ChangeStackNameHandler extends Handler

  @route 'post /{orgid}/stacks/{stackid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve stack'
    'ensure org has active subscription'
    'ensure stack belongs to org'
    'ensure requester can access stack'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stack} = request.pre
    {user}       = request.auth.credentials
    {name}       = request.payload

    unless stack.type == StackType.Backlog
      return reply @error.badRequest("Cannot change the name of a stack with type #{stack.type}")

    command = new ChangeStackNameCommand(user, stack, name)
    @processor.execute command, (err, stack) =>
      return reply err if err?
      return reply @response(stack)

module.exports = ChangeStackNameHandler
