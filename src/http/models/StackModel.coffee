Model = require 'http/framework/Model'

class StackModel extends Model

  @describes: 'Stack'
  @getUri: (id, request) -> "#{request.scope.organization.id}/stacks/#{id}"

  load: (stack) ->
    @name = stack.name
    @type = stack.type
    @organization = @one('organization', stack.organization)
    @owner = @one('owner', stack.owner) if stack.owner?
    @team = @one('team', stack.team) if stack.team?
    @cards = @many('cards', stack.cards)

module.exports = StackModel
