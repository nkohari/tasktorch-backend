MoveType = require 'domain/enums/MoveType'

class Move

  constructor: (user, previousStack, currentStack) ->
    @time = new Date()
    @type = if previousStack.user == currentStack.user then MoveType.Move else MoveType.Pass
    @user = user.id
    @from = @stackEntry(previousStack)
    @to   = @stackEntry(currentStack)

  stackEntry: (stack) ->
    entry = {stack: stack.id}
    entry.user = stack.user if stack.user?
    entry.team = stack.team if stack.team?
    return entry

module.exports = Move
