Event = require '../framework/Event'

class SessionCreatedEvent extends Event

  constructor: (@session) ->
    super()

module.exports = SessionCreatedEvent
