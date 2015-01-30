Note = require 'data/documents/Note'

class CardMovedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardMoved'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from:
          owner: previous.owner ? null
          stack: previous.stack
        to:
          owner: card.owner ? null
          stack: card.stack
    }

module.exports = CardMovedNote
