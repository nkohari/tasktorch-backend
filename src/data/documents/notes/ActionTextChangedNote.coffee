Note = require 'data/documents/Note'

class ActionTextChangedNote

  @create: (user, action, previous) ->
    new Note {
      type:    'ActionTextChanged'
      user:    user.id
      org:     action.org
      card:    action.card
      content:
        action: action.id
        from:   previous.text
        to:     action.text
    }

module.exports = ActionTextChangedNote
