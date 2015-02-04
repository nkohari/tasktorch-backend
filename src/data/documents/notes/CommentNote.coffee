Note = require 'data/documents/Note'

class CommentNote

  @create: (user, card, content) ->
    new Note {
      type:    'Comment'
      user:    user.id
      org:     card.org
      card:    card.id
      content: content
    }

module.exports = CommentNote
