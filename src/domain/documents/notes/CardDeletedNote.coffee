Note = require './Note'

class CardDeletedNote extends Note

  constructor: (user, card, previous) ->
    super(user.id, card.org, card.id)
    @content =
      from:
        stack: previous.stack

module.exports = CardDeletedNote
