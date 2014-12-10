Event      = require 'data/framework/Event'
Card       = require 'data/schemas/Card'
CardModel  = require 'http/models/CardModel'
StackModel = require 'http/models/StackModel'

class CardHandedOffEvent extends Event

  constructor: (organization, user, card, oldStack, newStack) ->
    super(card, user)
    @organization = organization.id
    @payload =
      card:     new CardModel(card)
      oldStack: new StackModel(oldStack)
      newStack: new StackModel(newStack)

module.exports = CardHandedOffEvent
