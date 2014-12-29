Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
CardStatus                    = require 'data/enums/CardStatus'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class ArchiveCardCommand extends Command

  constructor: (@cardId) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateCardStatement(@cardId, {status: CardStatus.Archived, stack: null})
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.card = card
      result.changed(card)
      statement = new RemoveCardFromStacksStatement(@cardId)
      conn.execute statement, (err, stacks) =>
        return callback(err) if err?
        result.changed(stacks)
        callback(null, result)

module.exports = ArchiveCardCommand
