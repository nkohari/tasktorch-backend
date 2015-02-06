Command                 = require 'domain/framework/Command'
CardCreatedNote         = require 'data/documents/notes/CardCreatedNote'
AddCardToStackStatement = require 'data/statements/AddCardToStackStatement'
CreateStatement         = require 'data/statements/CreateStatement'

class CreateCardCommand extends Command

  constructor: (@user, @card) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@card)
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(card.stack, card.id, 'append')
      conn.execute statement, (err, stack) =>
        return callback(err) if err?
        note = CardCreatedNote.create(@user, card)
        statement = new CreateStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, card)

module.exports = CreateCardCommand
