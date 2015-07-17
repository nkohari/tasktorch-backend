Command                           = require 'domain/framework/Command'
Card                              = require 'data/documents/Card'
CardCompletedNote                 = require 'data/documents/notes/CardCompletedNote'
CardStatus                        = require 'data/enums/CardStatus'
CreateStatement                   = require 'data/statements/CreateStatement'
CompleteAllActionsByCardStatement = require 'data/statements/CompleteAllActionsByCardStatement'
RemoveCardFromStacksStatement     = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement                   = require 'data/statements/UpdateStatement'

class CompleteCardCommand extends Command

  constructor: (@user, @cardid) ->

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, stacks) =>
      return callback(err) if err?
      statement = new CompleteAllActionsByCardStatement(@cardid)
      conn.execute statement, (err, actions) =>
        return callback(err) if err?
        statement = new UpdateStatement(Card, @cardid, {
          status: CardStatus.Complete
          user:   null
          team:   null
          stack:  null
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardCompletedNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = CompleteCardCommand
