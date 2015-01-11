r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
Move                          = require 'domain/documents/Move'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

class MoveCardCommand extends Command

  constructor: (@user, @cardId, @stackId, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardId)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.messages.changed(previousStacks)
      # TODO: Cards should only be in one stack at a time. The RemoveCardFromStackStatement
      # ensures that we'll be putting the card into only one stack, so previousStacks
      # should almost always only contain a single stack. This is here just to be sure.
      previousStack = previousStacks[0]
      statement = new AddCardToStackStatement(@stackId, @cardId, @position)
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        patch = {stack: @stackId, owner: currentStack.user ? null}
        if previousStack.id != currentStack.id
          move = new Move(@user, previousStack, currentStack)
          patch.moves = r.row('moves').append(move)
        statement = new UpdateCardStatement(@cardId, patch)
        conn.execute statement, (err, card) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.card = card
          callback(null, result)

module.exports = MoveCardCommand
