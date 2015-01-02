Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
CardStatus                    = require 'data/enums/CardStatus'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class CompleteCardCommand extends Command

  constructor: (@user, @cardId) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateCardStatement(@cardId, {status: CardStatus.Complete, stack: null})
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.messages.changed(card)
      statement = new RemoveCardFromStacksStatement(@cardId)
      conn.execute statement, (err, stacks) =>
        return callback(err) if err?
        result.messages.changed(stacks)
        result.notes.completed(card)
        result.card = card
        callback(null, result)

module.exports = CompleteCardCommand
