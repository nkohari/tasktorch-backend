Event = require '../framework/Event'

class CardBodyEditedEvent extends Event

  constructor: (@card, @oldValue, @newValue) ->
    super()

module.exports = CardBodyEditedEvent
