r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
Card                          = require 'data/documents/Card'
CardPassedNote                = require 'data/documents/notes/CardPassedNote'
MoveType                      = require 'data/enums/MoveType'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
CreateStatement               = require 'data/statements/CreateStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement               = require 'data/statements/UpdateStatement'
Move                          = require 'data/structs/Move'

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
        statement = new UpdateStatement(Card, @card.id, {
          stack: currentStack.id
          owner: currentStack.user ? null
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardPassedNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = PassCardCommand
