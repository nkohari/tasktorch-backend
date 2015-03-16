Model = require 'domain/framework/Model'

class ActionModel extends Model

  constructor: (action) ->
    super(action)
    @text      = action.text
    @org       = action.org
    @card      = action.card
    @checklist = action.checklist
    @stage     = action.stage
    @user      = action.user ? null

module.exports = ActionModel
