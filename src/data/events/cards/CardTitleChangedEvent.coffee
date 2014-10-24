Event = require '../framework/Event'

class CardTitleChangedEvent extends Event

  constructor: (card, value, metadata) ->
    super(card, metadata)
    @value = value

module.exports = CardTitleChangedEvent
