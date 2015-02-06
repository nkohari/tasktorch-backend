Command              = require 'domain/framework/Command'
Card                 = require 'data/documents/Card'
CardTitleChangedNote = require 'data/documents/notes/CardTitleChangedNote'
UpdateStatement      = require 'data/statements/UpdateStatement'
CreateStatement      = require 'data/statements/CreateStatement'

class ChangeCardTitleCommand extends Command

  constructor: (@user, @cardid, @title) ->
    super()

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @cardid, {@title})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardTitleChangedNote.create(@user, card, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardTitleCommand
