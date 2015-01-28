Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CardStatus                    = require 'domain/enums/CardStatus'
CardCompletedNote             = require 'domain/documents/notes/CardCompletedNote'

class CompleteCardCommand extends Command

  constructor: (@user, @cardid) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      result.messages.changed(stacks)
      statement = new UpdateCardStatement(@cardid, {
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
