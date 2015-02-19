Note = require 'data/documents/Note'

class FollowerRemovedNote

  @create: (user, card, follower) ->
    new Note {
      type:    'FollowerRemoved'
      user:    user.id
      org:     card.org
      card:    card.id
      content: {user: follower.id}
    }

module.exports = FollowerRemovedNote
