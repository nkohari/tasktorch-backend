Note = require 'data/documents/Note'

class ActionMovedNote

  @create: (user, action, previous) ->
    new Note {
      type:    'ActionMoved'
      user:    user.id
      org:     action.org
      card:    action.card
      content:
        action: action.id
        from:   {card: previous.card, stage: previous.stage}
        to:     {card: action.card,   stage: action.stage}
    }

module.exports = ActionMovedNote
