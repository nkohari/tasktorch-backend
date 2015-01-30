Handler               = require 'http/framework/Handler'
ChangeUserNameCommand = require 'domain/commands/users/ChangeUserNameCommand'

class ChangeMyNameHandler extends Handler

  @route 'post /api/me/name'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {name} = request.payload

    unless name?.length > 0
      return reply @error.badRequest("Missing required parameter 'name'")

    command = new ChangeUserNameCommand(user, name)
    @processor.execute command, (err, result) =>
      return reply err if err?
      reply @response(result.user)

module.exports = ChangeMyNameHandler
