Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

class HandOffCardCommand extends Command

  constructor: (@cardId, @stackId, @ownerId) ->
    super()

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new RemoveCardFromStacksStatement(@cardId)
    statement.execute conn, (err, previousStacks) =>
      return callback(err) if err?
      result.changed(previousStacks)
      statement = new AddCardToStackStatement(@stackId, @cardId, 'append')
      statement.execute conn, (err, currentStack) =>
        return callback(err) if err?
        result.changed(currentStack)
        statement = new UpdateCardStatement(@cardId, {stack: @stackId, owner: @ownerId})
        statement.execute conn, (err, card) =>
          return callback(err) if err?
          result.card = card
          result.changed(card)
          callback(null, result)

module.exports = HandOffCardCommand
