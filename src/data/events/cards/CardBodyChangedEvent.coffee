Event = require '../framework/Event'

class CardBodyChangedEvent extends Event

  constructor: (userId, @organizationId, @card, @oldValue, @newValue) ->
    super(userId)

module.exports = CardBodyChangedEvent
