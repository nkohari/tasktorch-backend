Note = require './Note'

class ActionCreatedNote extends Note

  constructor: (user, action) ->
    super(user.id, action.organization, action.card)
    @content =
      action: action.id

module.exports = ActionCreatedNote
