Handler               = require 'http/framework/Handler'
Response              = require 'http/framework/Response'
ChangeUserNameCommand = require 'domain/commands/ChangeUserNameCommand'

class ChangeMyNameHandler extends Handler

  @route 'put /api/me/name'

  constructor: (@processor) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    {name} = request.payload
    command = new ChangeUserNameCommand(user, name)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply new Response(result.user)

module.exports = ChangeMyNameHandler
