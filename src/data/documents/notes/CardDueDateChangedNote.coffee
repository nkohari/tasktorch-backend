Note = require 'data/documents/Note'

class CardDueDateChangedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardDueDateChanged'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from: previous.due ? null
        to:   card.due     ? null
    }

module.exports = CardDueDateChangedNote
