Note = require './Note'

class ActionStatusChangedNote extends Note

  constructor: (user, action, previous) ->
    super(user.id, action.organization, action.card)
    @content =
      action: action.id
      from:   previous.status
      to:     action.status

module.exports = ActionStatusChangedNote
