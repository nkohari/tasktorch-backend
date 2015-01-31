Handler                = require 'http/framework/Handler'
ChangeStackNameCommand = require 'domain/commands/stacks/ChangeStackNameCommand'

class ChangeStackNameHandler extends Handler

  @route 'post /api/{orgid}/stacks/{stackid}/name'

  @pre [
    'resolve org'
    'resolve stack'
    'ensure stack belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stack} = request.pre
    {user}       = request.auth.credentials
    {name}       = request.payload

    unless name?.length > 0
      return reply @error.badRequest("Missing required argument 'name'")

    command = new ChangeStackNameCommand(user, stack, name)
    @processor.execute command, (err, stack) =>
      return reply err if err?
      return reply @response(stack)

module.exports = ChangeStackNameHandler
