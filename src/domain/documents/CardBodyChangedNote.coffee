Note = require './Note'

class CardBodyChangedNote extends Note

  constructor: (user, card, previous) ->
    super(user, card)
    @content =
      from: previous.body ? null
      to:   card.body     ? null

module.exports = CardBodyChangedNote
