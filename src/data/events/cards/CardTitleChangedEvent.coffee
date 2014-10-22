Event = require '../framework/Event'

class CardTitleChangedEvent extends Event

  constructor: (userId, @organizationId, @card, @oldValue, @newValue) ->
    super(userId)

module.exports = CardTitleChangedEvent
