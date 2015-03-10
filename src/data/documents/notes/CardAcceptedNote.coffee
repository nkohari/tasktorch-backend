Note = require 'data/documents/Note'

class CardAcceptedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardAccepted'
      user:    user.id
      org:     card.org
      card:    card.id
      content:
        from:
          user:  previous.user ? null
          team:  previous.team ? null
          stack: previous.stack
        to:
          user:  card.user ? null
          stack: card.stack
    }

module.exports = CardAcceptedNote
