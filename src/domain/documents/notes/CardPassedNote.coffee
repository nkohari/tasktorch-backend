Note = require './Note'

class CardPassedNote extends Note

  constructor: (user, card, previous) ->
    super(user.id, card.organization, card.id)
    @content =
      from:
        owner: previous.owner ? null
        stack: previous.stack
      to:
        owner: card.owner
        stack: card.stack

module.exports = CardPassedNote
