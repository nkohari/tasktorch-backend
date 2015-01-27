Model = require 'domain/Model'

class ActionModel extends Model

  constructor: (action) ->
    super(action)
    @text  = action.text
    @org   = action.org
    @card  = action.card
    @owner = action.owner ? null
    @stage = action.stage

module.exports = ActionModel
