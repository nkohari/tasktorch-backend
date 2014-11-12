Model = require 'http/framework/Model'

class StackModel extends Model

  @describes: 'Stack'
  @getUri: (id, request) -> "#{request.scope.organization.id}/stacks/#{id}"

  load: (stack) ->
    @name = stack.name
    @type = stack.type
    @organization = @one('organization', stack.organization)
    @owner = @one('owner', stack.owner)
    @team = @one('team', stack.team)

module.exports = StackModel
