Command                       = require 'domain/framework/Command'
Card                          = require 'data/documents/Card'
CardDeletedNote               = require 'data/documents/notes/CardDeletedNote'
CardStatus                    = require 'data/enums/CardStatus'
CreateStatement               = require 'data/statements/CreateStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement               = require 'data/statements/UpdateStatement'

class DeleteCardCommand extends Command

  constructor: (@user, @card) ->

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@card.id)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      statement = new UpdateStatement(Card, @card.id, {
        owner:  null
        stack:  null
        status: CardStatus.Deleted
      })
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        note = CardDeletedNote.create(@user, card, previous)
        statement = new CreateStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, card)

module.exports = DeleteCardCommand
