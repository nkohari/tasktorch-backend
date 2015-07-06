Command                             = require 'domain/framework/Command'
DeleteStatement                     = require 'data/statements/DeleteStatement'
RemoveActionFromChecklistsStatement = require 'data/statements/RemoveActionFromChecklistsStatement'
DeleteAllNotesByActionStatement     = require 'data/statements/DeleteAllNotesByActionStatement'

class DeleteActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    statement = new DeleteStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      statement = new RemoveActionFromChecklistsStatement(@action.id)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        statement = new DeleteAllNotesByActionStatement(@action.id)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, action)

module.exports = DeleteActionCommand
