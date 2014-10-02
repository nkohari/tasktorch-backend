Model = require '../framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card.id)
    @title = card.title
    @body = card.body
    @owner = card.owner
    @participants = card.participants

module.exports = CardModel
