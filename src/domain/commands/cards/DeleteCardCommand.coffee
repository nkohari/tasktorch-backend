Command                       = require 'domain/framework/Command'
CardDeletedNote               = require 'data/documents/notes/CardDeletedNote'
DeleteCardStatement           = require 'data/statements/DeleteCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

class DeleteCardCommand extends Command

  constructor: (@user, @card) ->

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@card.id)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      statement = new DeleteCardStatement(@card.id)
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        note = CardDeletedNote.create(@user, card, previous)
        statement = new CreateNoteStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, card)

module.exports = DeleteCardCommand
