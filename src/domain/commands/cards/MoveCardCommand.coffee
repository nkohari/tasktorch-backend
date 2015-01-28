r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
Move                          = require 'domain/documents/Move'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
CardMovedNote                 = require 'domain/documents/notes/CardMovedNote'

class MoveCardCommand extends Command

  constructor: (@user, @cardid, @stackid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(@stackid, @cardid, @position)
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        patch = {stack: @stackid, owner: currentStack.user ? null}
        # TODO: Cards should only be in one stack at a time. The RemoveCardFromStackStatement
        # ensures that we'll be putting the card into only one stack, so previousStacks
        # should almost always only contain a single stack. This is here just to be sure.
        previousStack = previousStacks[0]
        if previousStack.id != currentStack.id
          move = new Move(@user, previousStack, currentStack)
          patch.moves = r.row('moves').append(move)
          result.messages.changed(previousStacks)
        statement = new UpdateCardStatement(@cardid, patch)
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.addNote(new CardMovedNote(@user, card, previous))
          result.card = card
          callback(null, result)

module.exports = MoveCardCommand
