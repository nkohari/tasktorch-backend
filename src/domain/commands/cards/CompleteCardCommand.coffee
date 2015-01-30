Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
CardCompletedNote             = require 'data/documents/notes/CardCompletedNote'
CardStatus                    = require 'data/enums/CardStatus'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

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
        result.addNote(CardCompletedNote.create(@user, card, previous))
        result.card = card
        callback(null, result)

module.exports = CompleteCardCommand
