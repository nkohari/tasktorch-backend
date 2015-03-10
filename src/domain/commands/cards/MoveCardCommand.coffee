r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
Card                          = require 'data/documents/Card'
CardMovedNote                 = require 'data/documents/notes/CardMovedNote'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
CreateStatement               = require 'data/statements/CreateStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement               = require 'data/statements/UpdateStatement'
Move                          = require 'data/structs/Move'

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
        patch = {
          stack: @stackid
          user: currentStack.user ? null
          team: currentStack.team ? null
        }
        # TODO: Cards should only be in one stack at a time. The RemoveCardFromStackStatement
        # ensures that we'll be putting the card into only one stack, so previousStacks
        # should almost always only contain a single stack. This is here just to be sure.
        previousStack = previousStacks[0]
        if previousStack.id != currentStack.id
          move = new Move(@user, previousStack, currentStack)
          patch.moves = r.row('moves').append(move)
        statement = new UpdateStatement(Card, @cardid, patch)
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardMovedNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = MoveCardCommand
