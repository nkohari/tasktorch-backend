Note = require './Note'

class CardAcceptedNote extends Note

  constructor: (user, card, previous) ->
    super(user.id, card.org, card.id)
    @content =
      from:
        owner: previous.owner ? null
        stack: previous.stack
      to:
        owner: card.owner
        stack: card.stack

module.exports = CardAcceptedNote
