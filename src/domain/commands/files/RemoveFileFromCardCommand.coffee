r                       = require 'rethinkdb'
Card                    = require 'data/documents/Card'
FileRemovedFromCardNote = require 'data/documents/notes/FileRemovedFromCardNote'
CreateStatement         = require 'data/statements/CreateStatement'
UpdateStatement         = require 'data/statements/UpdateStatement'
Command                 = require 'domain/framework/Command'

class RemoveFileFromCardCommand extends Command

  constructor: (@user, @file, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @card.id, {
      files: r.row('files').setDifference([@file.id])
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      note = FileRemovedFromCardNote.create(@user, @card, @file)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = RemoveFileFromCardCommand
