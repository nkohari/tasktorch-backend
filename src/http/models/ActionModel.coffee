Model = require 'http/framework/Model'

class ActionModel extends Model

  @describes: 'Action'
  @getUri: (id, request) -> "#{request.scope.organization.id}/actions/#{id}"

  load: (action) ->
    @text = action.text
    @status = action.status
    @card = @one('card', action.card)
    @owner = @one('owner', action.owner) if action.owner?
    @stage = @one('stage', action.stage)

module.exports = ActionModel
