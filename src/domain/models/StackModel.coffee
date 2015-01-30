Model = require 'domain/framework/Model'

class StackModel extends Model

  constructor: (stack) ->
    super(stack)
    @name  = stack.name
    @type  = stack.type
    @org   = stack.org
    @user  = stack.user if stack.user?
    @team  = stack.team if stack.team?
    @cards = stack.cards

module.exports = StackModel
