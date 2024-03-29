Model = require 'domain/framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card)
    @title     = card.title
    @summary   = card.summary
    @kind      = card.kind
    @number    = card.number
    @creator   = card.creator
    @org       = card.org
    @user      = card.user ? null
    @team      = card.team ? null
    @followers = card.followers
    @stack     = card.stack
    @goals     = card.goals
    @stages    = card.stages
    @files     = card.files
    @due       = card.due    if card.due?
    @effort    = card.effort if card.effort?
    @moves     = card.moves

module.exports = CardModel
