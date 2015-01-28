Handler           = require 'http/framework/Handler'
EndSessionCommand = require 'domain/commands/sessions/EndSessionCommand'

class EndSessionHandler extends Handler

  @route 'delete /api/sessions/{sessionid}'

  constructor: (@processor) ->

  handle: (request, reply) ->
    {session, user} = request.auth.credentials
    command = new EndSessionCommand(user, session.id)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      request.auth.session.clear()
      reply()

module.exports = EndSessionHandler
