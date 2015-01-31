Command                = require 'domain/framework/Command'
CardSummaryChangedNote = require 'data/documents/notes/CardSummaryChangedNote'
UpdateCardStatement    = require 'data/statements/UpdateCardStatement'
CreateNoteStatement    = require 'data/statements/CreateNoteStatement'

class ChangeCardSummaryCommand extends Command

  constructor: (@user, @cardid, @summary) ->
    super()

  execute: (conn, callback) ->
    statement = new UpdateCardStatement(@cardid, {@summary})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardSummaryChangedNote.create(@user, card, previous)
      statement = new CreateNoteStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardSummaryCommand
