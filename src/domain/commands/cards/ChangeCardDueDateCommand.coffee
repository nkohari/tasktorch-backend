Command                = require 'domain/framework/Command'
Card                   = require 'data/documents/Card'
CardDueDateChangedNote = require 'data/documents/notes/CardDueDateChangedNote'
CreateStatement        = require 'data/statements/CreateStatement'
UpdateStatement        = require 'data/statements/UpdateStatement'

class ChangeCardDueDateCommand extends Command

  constructor: (@user, @cardid, @due) ->
    super()

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @cardid, {@due})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardDueDateChangedNote.create(@user, card, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardDueDateCommand
