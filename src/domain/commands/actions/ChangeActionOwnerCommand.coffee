Command                = require 'domain/framework/Command'
Action                 = require 'data/documents/Action'
ActionOwnerChangedNote = require 'data/documents/notes/ActionOwnerChangedNote'
UpdateStatement        = require 'data/statements/UpdateStatement'
CreateStatement        = require 'data/statements/CreateStatement'

class ChangeActionOwnerCommand extends Command

  constructor: (@user, @action, @owner) ->

  execute: (conn, callback) ->
    if @owner?
      patch = {owner: if @owner? then @owner.id else null}
    else
      patch = {owner: null}
    statement = new UpdateStatement(Action, @action.id, patch)
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      note = ActionOwnerChangedNote.create(@user, action, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, action)

module.exports = ChangeActionOwnerCommand
