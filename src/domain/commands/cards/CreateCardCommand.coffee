Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
CardCreatedNote         = require 'domain/documents/notes/CardCreatedNote'
CreateCardStatement     = require 'data/statements/CreateCardStatement'
AddCardToStackStatement = require 'data/statements/AddCardToStackStatement'

class CreateCardCommand extends Command

  constructor: (@user, @card) ->

  execute: (conn, callback) ->
    result = new CommandResult(@user)
    statement = new CreateCardStatement(@card)
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.messages.created(card)
      statement = new AddCardToStackStatement(card.stack, card.id, 'append')
      conn.execute statement, (err, stack) =>
        return callback(err) if err?
        result.messages.changed(stack)
        result.addNote(new CardCreatedNote(@user, card))
        result.card = card
        callback(null, result)

module.exports = CreateCardCommand
