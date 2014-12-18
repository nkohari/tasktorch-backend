Model = require 'domain/Model'

class StackModel extends Model

  constructor: (stack) ->
    super(stack)
    @name         = stack.name
    @type         = stack.type
    @organization = stack.organization
    @owner        = stack.owner if stack.owner?
    @team         = stack.team if stack.team?
    @cards        = stack.cards

module.exports = StackModel
