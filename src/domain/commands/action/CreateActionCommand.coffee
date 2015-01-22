Command                  = require 'domain/Command'
CommandResult            = require 'domain/CommandResult'
ActionCreatedNote        = require 'domain/documents/ActionCreatedNote'
CreateActionStatement    = require 'data/statements/CreateActionStatement'
AddActionToCardStatement = require 'data/statements/AddActionToCardStatement'

class CreateActionCommand extends Command

  constructor: (@user, @action, @cardId) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new CreateActionStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      result.messages.created(action)
      statement = new AddActionToCardStatement(action.id, @cardId, action.stage, 'append')
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(new ActionCreatedNote(@user, action))
        result.action = action
        callback(null, result)

module.exports = CreateActionCommand
