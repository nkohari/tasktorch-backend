Model = require 'domain/framework/Model'

class ActionModel extends Model

  constructor: (action) ->
    super(action)
    @text  = action.text
    @org   = action.org
    @card  = action.card
    @user  = action.user ? null
    @stage = action.stage

module.exports = ActionModel
