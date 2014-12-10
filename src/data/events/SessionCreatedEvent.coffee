Event        = require 'data/framework/Event'
Session      = require 'data/schemas/Session'
SessionModel = require 'http/models/SessionModel'

class SessionCreatedEvent extends Event

  constructor: (session, user) ->
    super(session, user)
    @payload = new SessionModel(session)

module.exports = SessionCreatedEvent
