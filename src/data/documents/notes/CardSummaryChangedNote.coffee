Note = require 'data/documents/Note'

class CardSummaryChangedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardSummaryChanged'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from: previous.summary ? null
        to:   card.summary     ? null
    }

module.exports = CardSummaryChangedNote
