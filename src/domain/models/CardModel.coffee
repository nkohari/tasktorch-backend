Model = require 'domain/framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card)
    @title      = card.title
    @summary    = card.summary
    @kind       = card.kind
    @number     = card.number
    @creator    = card.creator
    @org        = card.org
    @user       = card.user ? null
    @team       = card.team ? null
    @followers  = card.followers
    @stack      = card.stack
    @goal       = card.goal ? null
    @milestone  = card.milestone ? null
    @moves      = card.moves

module.exports = CardModel
