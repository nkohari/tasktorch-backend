Note = require 'data/documents/Note'

class ActionDeletedNote

  @create: (user, action) ->
    new Note {
      type:    'ActionDeleted'
      user:    user.id
      org:     action.org
      card:    action.card
      content:
        action: action.id
    }

module.exports = ActionDeletedNote
