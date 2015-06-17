Note = require 'data/documents/Note'

class ActionOwnerChangedNote

  @create: (user, action, previous) ->
    new Note {
      type:    'ActionOwnerChanged'
      user:    user.id
      org:     action.org
      card:    action.card
      content:
        action: action.id
        from:   previous.user ? null
        to:     action.user   ? null
    }

module.exports = ActionOwnerChangedNote
