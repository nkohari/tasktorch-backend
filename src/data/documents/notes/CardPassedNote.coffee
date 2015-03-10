Note = require 'data/documents/Note'

class CardPassedNote

  @create: (user, card, previous) ->
    new Note {
      type:    'CardPassed'
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
          team:  card.team ? null
          stack: card.stack
    }

module.exports = CardPassedNote
