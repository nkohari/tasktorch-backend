Model = require 'http/framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card)
    @title        = card.title
    @body         = card.body
    @kind         = card.kind
    @creator      = card.creator
    @owner        = card.owner ? null
    @participants = card.participants
    @stack        = card.stack
    @actions      = card.actions
    @goal         = card.goal ? null
    @milestone    = card.milestone ? null
    @lastHandoff  = card.lastHandoff ? null

module.exports = CardModel
