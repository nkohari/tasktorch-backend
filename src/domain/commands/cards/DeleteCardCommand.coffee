Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
DeleteCardStatement           = require 'data/statements/DeleteCardStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CardDeletedNote               = require 'domain/documents/notes/CardDeletedNote'

class DeleteCardCommand extends Command

  constructor: (@user, @card) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@card.id)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      result.messages.changed(stacks)
      statement = new DeleteCardStatement(@card.id)
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        result.messages.changed(card)
        result.addNote(new CardDeletedNote(@user, card, previous))
        result.card = card
        callback(null, result)

module.exports = DeleteCardCommand
