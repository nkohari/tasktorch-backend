r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
CardPassedNote                = require 'data/documents/notes/CardPassedNote'
Move                          = require 'data/structs/Move'
MoveType                      = require 'data/enums/MoveType'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

class PassCardCommand extends Command

  constructor: (@user, @card, @stack) ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@card.id)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(@stack.id, @card.id, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        move = new Move(@user, previousStacks[0], currentStack)
        statement = new UpdateCardStatement(@card.id, {
          stack: currentStack.id
          owner: currentStack.owner ? null
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardPassedNote.create(@user, card, previous)
          statement = new CreateNoteStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = PassCardCommand
