Command                = require 'domain/framework/Command'
Card                   = require 'data/documents/Card'
CardSummaryChangedNote = require 'data/documents/notes/CardSummaryChangedNote'
CreateStatement        = require 'data/statements/CreateStatement'
UpdateStatement        = require 'data/statements/UpdateStatement'

class ChangeCardSummaryCommand extends Command

  constructor: (@user, @cardid, @summary) ->
    super()

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @cardid, {@summary})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardSummaryChangedNote.create(@user, card, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardSummaryCommand
