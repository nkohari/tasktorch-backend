Event   = require 'data/framework/Event'
Session = require 'data/schemas/Session'

class SessionEndedEvent extends Event

  constructor: (session, user) ->
    super(session, user)
    @payload = {}

module.exports = SessionEndedEvent
