Command                          = require 'domain/framework/Command'
CardCreatedNote                  = require 'data/documents/notes/CardCreatedNote'
AddCardToStackStatement          = require 'data/statements/AddCardToStackStatement'
CreateChecklistsForCardStatement = require 'data/statements/CreateChecklistsForCardStatement'
CreateStatement                  = require 'data/statements/CreateStatement'
IncrementKindNumberStatement     = require 'data/statements/IncrementKindNumberStatement'

class CreateCardCommand extends Command

  constructor: (@user, @card, @kind) ->

  execute: (conn, callback) ->
    statement = new IncrementKindNumberStatement(@kind.id)
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      @card.number = kind.nextNumber
      statement = new CreateStatement(@card)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        statement = new CreateChecklistsForCardStatement(card.org, card.id, @kind.stages)
        conn.execute statement, (err) =>
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
