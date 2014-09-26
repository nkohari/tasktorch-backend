Handler = require '../../framework/Handler'

class EndSessionHandler extends Handler

  @route 'delete /sessions/{sessionId}'

  constructor: (@database) ->

  handle: (request, reply) ->
    {session} = request.auth.credentials
    session.end()
    @database.save session, (err) =>
      return reply err if err?
      request.auth.session.clear()
      reply()

module.exports = EndSessionHandler
