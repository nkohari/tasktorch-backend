Command                       = require 'domain/framework/Command'
CardCompletedNote             = require 'data/documents/notes/CardCompletedNote'
CardStatus                    = require 'data/enums/CardStatus'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

class CompleteCardCommand extends Command

  constructor: (@user, @cardid) ->

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      statement = new UpdateCardStatement(@cardid, {
        status: CardStatus.Complete
        owner:  null
        stack:  null
      })
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        note = CardCompletedNote.create(@user, card, previous)
        statement = new CreateNoteStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, card)

module.exports = CompleteCardCommand
