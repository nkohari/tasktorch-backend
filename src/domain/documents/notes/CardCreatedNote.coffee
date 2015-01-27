Note = require './Note'

class CardCreatedNote extends Note

  constructor: (user, card) ->
    super(user.id, card.org, card.id)

module.exports = CardCreatedNote
