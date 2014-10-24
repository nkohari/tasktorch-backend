Event = require '../framework/Event'

class CardBodyChangedEvent extends Event

  constructor: (card, value, metadata) ->
    super(card, metadata)
    @value = value

module.exports = CardBodyChangedEvent
