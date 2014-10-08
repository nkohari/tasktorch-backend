Model = require '../framework/Model'

class StackModel extends Model

  constructor: (baseUrl, stack) ->
    super(stack.id)
    @name = stack.name
    @kind = stack.kind
    @organization = stack.organization
    @owner = stack.owner
    @team = stack.team
    @cards = stack.cards
    @uri = "#{baseUrl}/#{@organization.id}/stacks/#{@id}"

module.exports = StackModel
