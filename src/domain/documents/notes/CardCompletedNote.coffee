Note = require './Note'

class CardCompletedNote extends Note

  constructor: (user, card, previous) ->
    super(user.id, card.org, card.id)
    @content =
      from:
        stack: previous.stack

module.exports = CardCompletedNote
