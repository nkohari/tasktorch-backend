r                                  = require 'rethinkdb'
Command                            = require 'domain/framework/Command'
Card                               = require 'data/documents/Card'
CardRestoredNote                   = require 'data/documents/notes/CardRestoredNote'
CardStatus                         = require 'data/enums/CardStatus'
AddCardToStackStatement            = require 'data/statements/AddCardToStackStatement'
CreateStatement                    = require 'data/statements/CreateStatement'
UpdateStatement                    = require 'data/statements/UpdateStatement'
UpdateCardStagesAndStatusStatement = require 'data/statements/UpdateCardStagesAndStatusStatement'

class RestoreCardCommand extends Command

  constructor: (@user, @cardid, @stackid) ->
    super()

  execute: (conn, callback) ->
    statement = new AddCardToStackStatement(@stackid, @cardid, 'append')
    conn.execute statement, (err, currentStack) =>
      return callback(err) if err?

      patch = {
        stack:     @stackid
        user:      @user.id
        followers: r.row('followers').setInsert(@user.id)
      }

      statement = new UpdateStatement(Card, @cardid, patch)
      conn.execute statement, (err, card, previous) =>
        return callback(err) if err?
        statement = new UpdateCardStagesAndStatusStatement(@cardid)
        conn.execute statement, (err, card) =>
          return callback(err) if err?
          note = CardRestoredNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = RestoreCardCommand
