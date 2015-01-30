Note = require 'data/documents/Note'

class ActionStatusChangedNote

  @create: (user, action, previous) ->
    new Note {
      type:    'ActionStatusChanged'
      user:    user.id
      org:     action.org
      card:    action.card
      content:
        action: action.id
        from:   previous.status
        to:     action.status
    }

module.exports = ActionStatusChangedNote
