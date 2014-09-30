Model = require '../framework/Model'

class StackModel extends Model

  constructor: (baseUrl, stack) ->
    super(stack.id)
    @name = stack.name
    @organization = stack.organization
    @owner = stack.owner
    @team = stack.team
    @cards = stack.cards
    @uri = "#{baseUrl}/organizations/#{@organization.id}/stacks/#{@id}"

module.exports = StackModel