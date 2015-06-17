Note = require 'data/documents/Note'

class CardTitleChangedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardTitleChanged'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from: previous.title ? null
        to:   card.title     ? null
    }

module.exports = CardTitleChangedNote
