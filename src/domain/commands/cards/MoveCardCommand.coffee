r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
CardMovedNote                 = require 'data/documents/notes/CardMovedNote'
Move                          = require 'data/structs/Move'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

class MoveCardCommand extends Command

  constructor: (@user, @cardid, @stackid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(@stackid, @cardid, @position)
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        patch = {stack: @stackid, owner: currentStack.user ? null}
        # TODO: Cards should only be in one stack at a time. The RemoveCardFromStackStatement
        # ensures that we'll be putting the card into only one stack, so previousStacks
        # should almost always only contain a single stack. This is here just to be sure.
        previousStack = previousStacks[0]
        if previousStack.id != currentStack.id
          move = new Move(@user, previousStack, currentStack)
          patch.moves = r.row('moves').append(move)
        statement = new UpdateCardStatement(@cardid, patch)
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardMovedNote.create(@user, card, previous)
          statement = new CreateNoteStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = MoveCardCommand
