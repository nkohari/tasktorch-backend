Command              = require 'domain/framework/Command'
CardTitleChangedNote = require 'data/documents/notes/CardTitleChangedNote'
UpdateCardStatement  = require 'data/statements/UpdateCardStatement'
CreateNoteStatement  = require 'data/statements/CreateNoteStatement'

class ChangeCardTitleCommand extends Command

  constructor: (@user, @cardid, @title) ->
    super()

  execute: (conn, callback) ->
    statement = new UpdateCardStatement(@cardid, {@title})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardTitleChangedNote.create(@user, card, previous)
      statement = new CreateNoteStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardTitleCommand
