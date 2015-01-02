Model = require 'domain/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card)
    @title        = card.title
    @body         = card.body
    @kind         = card.kind
    @creator      = card.creator
    @organization = card.organization
    @owner        = card.owner ? null
    @participants = card.participants
    @stack        = card.stack
    @actions      = card.actions
    @goal         = card.goal ? null
    @milestone    = card.milestone ? null
    @notes        = card.notes if card.notes?

module.exports = CardModel
