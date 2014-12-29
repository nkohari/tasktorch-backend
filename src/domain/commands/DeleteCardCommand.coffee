Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
DeleteCardStatement           = require 'data/statements/DeleteCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class DeleteCardCommand extends Command

  constructor: (@cardId) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new DeleteCardStatement(@cardId)
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.card = card
      result.changed(card)
      statement = new RemoveCardFromStacksStatement(@cardId)
      conn.execute statement, (err, stacks) =>
        return callback(err) if err?
        result.changed(stacks)
        callback(null, result)

module.exports = DeleteCardCommand
