Note = require 'data/documents/Note'

class CardEffortChangedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardEffortChanged'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from: previous.effort ? null
        to:   card.effort     ? null
    }

module.exports = CardEffortChangedNote
