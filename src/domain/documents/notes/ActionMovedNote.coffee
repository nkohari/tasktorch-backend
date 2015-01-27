Note = require './Note'

class ActionMovedNote extends Note

  constructor: (user, action, previous) ->
    super(user.id, action.organization, action.card)
    @content =
      action: action.id
      from:   {card: previous.card, stage: previous.stage}
      to:     {card: action.card,   stage: action.stage}

module.exports = ActionMovedNote
