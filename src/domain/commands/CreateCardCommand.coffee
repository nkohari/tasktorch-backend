Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
CreateCardStatement     = require 'data/statements/CreateCardStatement'
AddCardToStackStatement = require 'data/statements/AddCardToStackStatement'

class CreateCardCommand extends Command

  constructor: (@data, @stackId) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new CreateCardStatement(@data)
    statement.execute conn, (err, card) =>
      return callback(err) if err?
      result.card = card
      result.created(card)
      statement = new AddCardToStackStatement(@stackId, card.id, 'append')
      statement.execute conn, (err, stack) =>
        return callback(err) if err?
        result.changed(stack)
        callback(null, result)

module.exports = CreateCardCommand
