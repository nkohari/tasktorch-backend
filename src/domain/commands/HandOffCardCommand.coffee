Command                             = require 'domain/Command'
CommandResult                       = require 'domain/CommandResult'
RemoveCardFromCurrentStackStatement = require 'data/statements/RemoveCardFromCurrentStackStatement'
AddCardToStackStatement             = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement                 = require 'data/statements/UpdateCardStatement'

class HandOffCardCommand extends Command

  constructor: (@cardId, @stackId, @ownerId) ->
    super()

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateCardStatement(@cardId, {stack: @stackId, owner: @ownerId})
    statement.execute conn, (err, card) =>
      return callback(err) if err?
      result.card = card
      result.changed(card)
      statement = new RemoveCardFromCurrentStackStatement(card.id)
      statement.execute conn, (err, previousStack) =>
        return callback(err) if err?
        result.changed(previousStack)
        statement = new AddCardToStackStatement(@stackId, card.id, 'append')
        statement.execute conn, (err, currentStack) =>
          return callback(err) if err?
          result.changed(currentStack)
          callback(null, result)

module.exports = HandOffCardCommand
