Note = require './Note'

class ActionOwnerChangedNote extends Note

  constructor: (user, action, previous) ->
    super(user.id, action.organization, action.card)
    @content =
      action: action.id
      from:   previous.user ? null
      to:     action.user   ? null

module.exports = ActionOwnerChangedNote
