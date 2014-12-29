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
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.changed(previousStacks)
      statement = new AddCardToStackStatement(@stackId, @cardId, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.changed(currentStack)
        statement = new UpdateCardStatement(@cardId, {stack: @stackId, owner: @ownerId})
        conn.execute statement, (err, card) =>
          return callback(err) if err?
          result.card = card
          result.changed(card)
          callback(null, result)

module.exports = HandOffCardCommand
