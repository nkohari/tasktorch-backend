Note = require 'data/documents/Note'

class CardCompletedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardCompleted'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from:
          stack: previous.stack
    }

module.exports = CardCompletedNote
