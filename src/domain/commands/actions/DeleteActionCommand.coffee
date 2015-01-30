Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
ActionDeletedNote             = require 'data/documents/notes/ActionDeletedNote'
DeleteActionStatement         = require 'data/statements/DeleteActionStatement'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'

class DeleteActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new DeleteActionStatement(@action.id)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      result.messages.deleted(action)
      statement = new RemoveActionFromCardStatement(@action.id)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(ActionDeletedNote.create(@user, action))
        result.action = action
        callback(null, result)

module.exports = DeleteActionCommand
