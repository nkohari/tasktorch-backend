Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
CardStatus                    = require 'data/enums/CardStatus'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CardCompletedNote             = require 'domain/documents/notes/CardCompletedNote'

class CompleteCardCommand extends Command

  constructor: (@user, @cardId) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardId)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      result.messages.changed(stacks)
      statement = new UpdateCardStatement(@cardId, {
        status: CardStatus.Complete
        stack:  null
      })
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(new CardCompletedNote(@user, card, previous))
        result.card = card
        callback(null, result)

module.exports = CompleteCardCommand
