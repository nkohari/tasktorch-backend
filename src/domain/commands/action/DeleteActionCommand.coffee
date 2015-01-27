Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
DeleteActionStatement         = require 'data/statements/DeleteActionStatement'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'
ActionDeletedNote             = require 'domain/documents/notes/ActionDeletedNote'

class DeleteActionCommand extends Command

  constructor: (@user, @actionId) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new DeleteActionStatement(@actionId)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      result.messages.deleted(action)
      statement = new RemoveActionFromCardStatement(@actionId)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(new ActionDeletedNote(@user, action))
        result.action = action
        callback(null, result)

module.exports = DeleteActionCommand
