r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
Card                          = require 'data/documents/Card'
CardAcceptedNote              = require 'data/documents/notes/CardAcceptedNote'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
CreateStatement               = require 'data/statements/CreateStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement               = require 'data/statements/UpdateStatement'
Move                          = require 'data/structs/Move'

class AcceptCardCommand extends Command

  constructor: (@user, @cardid, @stackid) ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(@stackid, @cardid, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        move = new Move(@user, previousStacks[0], currentStack)
        statement = new UpdateStatement(Card, @cardid, {
          stack: @stackid
          owner: @user.id
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardAcceptedNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = AcceptCardCommand
