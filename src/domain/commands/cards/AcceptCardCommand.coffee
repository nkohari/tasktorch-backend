r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
Card                          = require 'data/documents/Card'
CardAcceptedNote              = require 'data/documents/notes/CardAcceptedNote'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
CreateStatement               = require 'data/statements/CreateStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
UpdateStatement               = require 'data/statements/UpdateStatement'
Move                          = require 'data/structs/Move'

class AcceptCardCommand extends Command

  constructor: (@user, @cardid, @stackid) ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      statement = new AddCardToStackStatement(@stackid, @cardid, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?

        patch = {
          stack:     @stackid
          user:      currentStack.user ? null
          team:      currentStack.team ? null
          moves:     r.row('moves').append(new Move(@user, previousStacks[0], currentStack))
        }

        if currentStack.user?
          patch.followers = r.row('followers').setInsert(currentStack.user)

        statement = new UpdateStatement(Card, @cardid, patch)
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          note = CardAcceptedNote.create(@user, card, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, card)

module.exports = AcceptCardCommand
