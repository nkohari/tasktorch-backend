Note = require 'data/documents/Note'

class FileRemovedFromCardNote

  @create: (user, card, file) ->
    new Note {
      type: 'FileRemovedFromCard'
      user: user.id
      org:  card.org
      card: card.id
      content:
        file: file.id
    }

module.exports = FileRemovedFromCardNote
