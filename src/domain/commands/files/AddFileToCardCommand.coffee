r                   = require 'rethinkdb'
Card                = require 'data/documents/Card'
FileAddedToCardNote = require 'data/documents/notes/FileAddedToCardNote'
CreateStatement     = require 'data/statements/CreateStatement'
UpdateStatement     = require 'data/statements/UpdateStatement'
Command             = require 'domain/framework/Command'

class AddFileToCardCommand extends Command

  constructor: (@user, @file, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @card.id, {
      files: r.row('files').setInsert(@file.id)
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      note = FileAddedToCardNote.create(@user, @card, @file)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = AddFileToCardCommand
