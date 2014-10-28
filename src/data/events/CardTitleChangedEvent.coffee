Event = require 'data/framework/Event'
Card  = require 'data/schemas/Card'

class CardTitleChangedEvent extends Event

  constructor: (card, user) ->
    super()
    @document = {type: Card.name, id: card.id, version: card.version}
    @meta     = {user: user.id, organization: card.organization}
    @payload  = {title: card.title}

module.exports = CardTitleChangedEvent
