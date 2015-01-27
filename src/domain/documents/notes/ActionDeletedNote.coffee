Note = require './Note'

class ActionDeletedNote extends Note

  constructor: (user, action) ->
    super(user.id, action.org, action.card)
    @content =
      action: action.id

module.exports = ActionDeletedNote
