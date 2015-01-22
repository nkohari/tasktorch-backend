Note = require './Note'

class CardSummaryChangedNote extends Note

  constructor: (user, card, previous) ->
    super(user.id, card.organization, card.id)
    @content =
      from: previous.summary ? null
      to:   card.summary     ? null

module.exports = CardSummaryChangedNote
