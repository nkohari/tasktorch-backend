Handler                   = require 'http/framework/Handler'
Response                  = require 'http/framework/Response'
ChangeUserPasswordCommand = require 'domain/commands/ChangeUserPasswordCommand'

class ChangeMyPasswordHandler extends Handler

  @route 'put /api/me/password'
  
  constructor: (@processor, @passwordHasher) ->

  handle: (request, reply) ->
    {user}     = request.auth.credentials
    {password} = request.payload
    hashedPassword = @passwordHasher.hash(password)
    command = new ChangeUserPasswordCommand(user, hashedPassword)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply()

module.exports = ChangeMyPasswordHandler
