Note = require 'data/documents/Note'

class CardCreatedNote

  @create: (user, card) ->
    new Note {
      type: 'CardCreated'
      user: user.id
      org:  card.org
      card: card.id
    }

module.exports = CardCreatedNote
