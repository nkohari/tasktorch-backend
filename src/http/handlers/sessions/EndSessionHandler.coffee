Handler = require '../../framework/Handler'

class EndSessionHandler extends Handler

  @route 'delete /sessions/{sessionId}'

  constructor: (@sessionService) ->

  handle: (request, reply) ->
    {session} = request.auth.credentials
    @sessionService.end session, (err) =>
      return reply err if err?
      request.auth.session.clear()
      reply()

module.exports = EndSessionHandler
