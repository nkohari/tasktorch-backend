Note = require 'data/documents/Note'

class FileAddedToCardNote

  @create: (user, card, file) ->
    new Note {
      type: 'FileAddedToCard'
      user: user.id
      org:  card.org
      card: card.id
      content:
        file: file.id
    }

module.exports = FileAddedToCardNote
