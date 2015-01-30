Model = require 'domain/framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card)
    @title     = card.title
    @summary   = card.summary
    @kind      = card.kind
    @creator   = card.creator
    @org       = card.org
    @owner     = card.owner ? null
    @followers = card.followers
    @stack     = card.stack
    @actions   = card.actions
    @goal      = card.goal ? null
    @milestone = card.milestone ? null
    @notes     = card.notes if card.notes?
    @moves     = card.moves

module.exports = CardModel
