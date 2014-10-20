Event = require '../framework/Event'

class CardTitleEditedEvent extends Event

  constructor: (@card, @oldValue, @newValue) ->
    super()

module.exports = CardTitleEditedEvent
