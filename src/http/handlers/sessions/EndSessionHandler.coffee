Handler           = require 'http/framework/Handler'
EndSessionCommand = require 'domain/commands/EndSessionCommand'

class EndSessionHandler extends Handler

  @route 'delete /api/sessions/{sessionId}'

  constructor: (@processor) ->

  handle: (request, reply) ->
    {session, user} = request.auth.credentials
    metadata = @getRequestMetadata()
    command = new EndSessionCommand(session, session.version)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      request.auth.session.clear()
      reply()

module.exports = EndSessionHandler
