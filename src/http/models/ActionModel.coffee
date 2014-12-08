Model = require 'http/framework/Model'

class ActionModel extends Model

  constructor: (action) ->
    super(action)
    @text   = action.text
    @status = action.status
    @card   = action.card
    @owner  = action.owner ? null
    @stage  = action.stage

module.exports = ActionModel
