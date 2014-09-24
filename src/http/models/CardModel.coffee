Model = require '../framework/Model'

class CardModel extends Model

  constructor: (card) ->
    super(card.id)
    @name = card.name
    @owner = card.owner
    @participants = card.participants

module.exports = CardModel
