Note = require './Note'

class CardSummaryChangedNote extends Note

  constructor: (user, card, previous) ->
    super(user, card)
    @content =
      from: previous.summary ? null
      to:   card.summary     ? null

module.exports = CardSummaryChangedNote
