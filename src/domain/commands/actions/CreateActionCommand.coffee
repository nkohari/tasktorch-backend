Command                  = require 'domain/framework/Command'
CommandResult            = require 'domain/framework/CommandResult'
ActionCreatedNote        = require 'data/documents/notes/ActionCreatedNote'
CreateActionStatement    = require 'data/statements/CreateActionStatement'
AddActionToCardStatement = require 'data/statements/AddActionToCardStatement'

class CreateActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new CreateActionStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      result.messages.created(action)
      statement = new AddActionToCardStatement(action.id, action.card, action.stage, 'append')
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(ActionCreatedNote.create(@user, action))
        result.action = action
        callback(null, result)

module.exports = CreateActionCommand
