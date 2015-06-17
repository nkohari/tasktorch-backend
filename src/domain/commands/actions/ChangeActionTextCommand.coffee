Command               = require 'domain/framework/Command'
Action                = require 'data/documents/Action'
ActionTextChangedNote = require 'data/documents/notes/ActionTextChangedNote'
CreateStatement       = require 'data/statements/CreateStatement'
UpdateStatement       = require 'data/statements/UpdateStatement'

class ChangeActionTextCommand extends Command

  constructor: (@user, @action, @text) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Action, @action.id, {@text})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      note = ActionTextChangedNote.create(@user, action, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, action)

module.exports = ChangeActionTextCommand
