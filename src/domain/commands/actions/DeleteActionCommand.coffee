Command                       = require 'domain/framework/Command'
ActionDeletedNote             = require 'data/documents/notes/ActionDeletedNote'
CreateStatement               = require 'data/statements/CreateStatement'
DeleteStatement               = require 'data/statements/DeleteStatement'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'

class DeleteActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    statement = new DeleteStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      statement = new RemoveActionFromCardStatement(@action.id)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        note = ActionDeletedNote.create(@user, action)
        statement = new CreateStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, action)

module.exports = DeleteActionCommand
