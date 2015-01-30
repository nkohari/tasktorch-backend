Note = require 'data/documents/Note'

class ActionCreatedNote

  @create: (user, action) ->
    new Note {
      type:    'ActionCreated'
      user:    user.id
      org:     action.org
      card:    action.card
      content: {action: action.id}
    }

module.exports = ActionCreatedNote
