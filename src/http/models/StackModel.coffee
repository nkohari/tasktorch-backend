Model = require '../framework/Model'

class StackModel extends Model

  getUri: (stack, request) ->
    "#{request.scope.organization.id}/stacks/#{stack.id}"

  assignProperties: (stack) ->
    @name = stack.name
    @kind = stack.kind
    @organization = @one('OrganizationModel', stack.organization)
    @owner = @one('UserModel', stack.owner)
    @team = @one('TeamModel', stack.team)
    @cards = @many('CardModel', stack.cards)

module.exports = StackModel
