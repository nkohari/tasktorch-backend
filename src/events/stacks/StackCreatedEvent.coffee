Event = require '../framework/Event'

class StackCreatedEvent extends Event

  constructor: (@stack) ->
    super()

module.exports = StackCreatedEvent
