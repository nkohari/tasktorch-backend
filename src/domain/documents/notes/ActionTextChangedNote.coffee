Note = require './Note'

class ActionTextChangedNote extends Note

  constructor: (user, action, previous) ->
    super(user.id, action.org, action.card)
    @content =
      action: action.id
      from:   previous.text ? null
      to:     action.text   ? null

module.exports = ActionTextChangedNote
