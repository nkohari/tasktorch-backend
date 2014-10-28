Handler = require 'http/framework/Handler'
EndSessionCommand = require 'data/commands/EndSessionCommand'
SessionEndedEvent = require 'data/events/SessionEndedEvent'

class EndSessionHandler extends Handler

  @route 'delete /api/sessions/{sessionId}'

  constructor: (@database) ->

  handle: (request, reply) ->
    {session, user} = request.auth.credentials
    metadata = @getRequestMetadata()
    command = new EndSessionCommand(session, session.version)
    @database.execute command, (err) =>
      return reply err if err?
      request.auth.session.clear()
      event = new SessionEndedEvent(session)
      @eventBus.publish event, metadata, (err) =>
        return reply err if err?
        reply()

module.exports = EndSessionHandler
