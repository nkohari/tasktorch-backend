Note = require './Note'

class CardCreatedNote extends Note

  constructor: (user, card) ->
    super(user, card)

module.exports = CardCreatedNote
