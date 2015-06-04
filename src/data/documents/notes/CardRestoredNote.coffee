Note = require 'data/documents/Note'

class CardDeletedNote
  
  @create: (user, card, previous) ->
    new Note {
      type:    'CardRestored'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        to:
          user:  card.user ? null
          stack: previous.stack
    }

module.exports = CardDeletedNote
