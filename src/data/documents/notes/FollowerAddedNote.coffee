Note = require 'data/documents/Note'

class FollowerAddedNote

  @create: (user, card, follower) ->
    new Note {
      type:    'FollowerAdded'
      user:    user.id
      org:     card.org
      card:    card.id
      content: {user: follower.id}
    }

module.exports = FollowerAddedNote
