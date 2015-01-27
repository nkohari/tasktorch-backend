Note = require './Note'

class CommentNote extends Note

  constructor: (user, card, content) ->
    super(user.id, card.org, card.id)
    @content = content

module.exports = CommentNote
