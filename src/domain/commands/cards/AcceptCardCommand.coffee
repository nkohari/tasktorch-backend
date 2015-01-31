r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
Move                          = require 'data/structs/Move'
CardAcceptedNote              = require 'data/documents/notes/CardAcceptedNote'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

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
        statement = new UpdateCardStatement(@cardid, {
          stack: @stackid
          owner: @user.id
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardAcceptedNote.create(@user, card, previous)
          statement = new CreateNoteStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = AcceptCardCommand
