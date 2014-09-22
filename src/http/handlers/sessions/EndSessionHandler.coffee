Handler = require '../../framework/Handler'

class EndSessionHandler extends Handler

  @route 'delete /sessions/{sessionId}'

  constructor: (log, @sessionService) ->
    super(log)

  handle: (request, reply) ->
    {session} = request.credentials
    session.isActive = false
    @sessionService.save session, (err) =>
      return reply @error(err) if err?
      request.auth.session.clear()
      reply()

module.exports = EndSessionHandler
