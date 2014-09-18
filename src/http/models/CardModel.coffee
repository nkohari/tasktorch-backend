Model = require '../framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card.id)
    @title = card.title
    @owner = card.owner
    @participants = card.participants

module.exports = CardModel
