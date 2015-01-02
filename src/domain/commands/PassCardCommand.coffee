Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

class PassCardCommand extends Command

  constructor: (@user, @cardId, @stackId, @ownerId) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardId)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.messages.changed(previousStacks)
      statement = new AddCardToStackStatement(@stackId, @cardId, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        statement = new UpdateCardStatement(@cardId, {stack: @stackId, owner: @ownerId})
        conn.execute statement, (err, card) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.notes.passed(card, @stackId, @ownerId)
          result.card = card
          callback(null, result)

module.exports = PassCardCommand
