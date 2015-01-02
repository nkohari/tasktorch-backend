Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
DeleteCardStatement           = require 'data/statements/DeleteCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class DeleteCardCommand extends Command

  constructor: (@user, @cardId) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new DeleteCardStatement(@cardId)
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.messages.changed(card)
      statement = new RemoveCardFromStacksStatement(@cardId)
      conn.execute statement, (err, stacks) =>
        return callback(err) if err?
        result.messages.changed(stacks)
        result.notes.deleted(card)
        result.card = card
        callback(null, result)

module.exports = DeleteCardCommand
