Note = require './Note'

class CardTitleChangedNote extends Note

  constructor: (user, card, previous) ->
    super(user, card)
    @content =
      from: previous.title ? null
      to:   card.title     ? null

module.exports = CardTitleChangedNote
