Model = require 'http/framework/Model'

class StackModel extends Model

  @describes: 'Stack'
  @getUri: (id, request) -> "#{request.scope.organization.id}/stacks/#{id}"

  load: (stack) ->
    @name = stack.name
    @kind = stack.kind
    @organization = @ref('organization', stack.organization)
    @owner = @ref('owner', stack.owner)
    @team = @ref('team', stack.team)

module.exports = StackModel
