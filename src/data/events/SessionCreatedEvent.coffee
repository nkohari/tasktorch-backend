Event   = require 'data/framework/Event'
Session = require 'data/schemas/Session'

class SessionCreatedEvent extends Event

  constructor: (session, user) ->
    super()
    @document = {type: Session.name, id: session.id, version: session.version}
    @meta     = {user: user.id}
    @payload  = session.toJSON()

module.exports = SessionCreatedEvent
