Note = require 'data/documents/Note'

class CardDeletedNote
  
  @create: (user, card, previous) ->
    new Note {
      type:    'CardDeleted'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from:
          stack: previous.stack
    }

module.exports = CardDeletedNote
