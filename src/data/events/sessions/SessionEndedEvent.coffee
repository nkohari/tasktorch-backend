Event = require '../framework/Event'

class SessionEndedEvent extends Event

  constructor: (@session) ->
    super()

module.exports = SessionEndedEvent
