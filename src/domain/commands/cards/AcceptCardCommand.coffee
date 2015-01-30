r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
Move                          = require 'data/structs/Move'
CardAcceptedNote              = require 'data/documents/notes/CardAcceptedNote'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

class AcceptCardCommand extends Command

  constructor: (@user, @cardid, @stackid) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardid)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.messages.changed(previousStacks)
      statement = new AddCardToStackStatement(@stackid, @cardid, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        move = new Move(@user, previousStacks[0], currentStack)
        statement = new UpdateCardStatement(@cardid, {
          stack: @stackid
          owner: @user.id
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.addNote(CardAcceptedNote.create(@user, card, previous))
          result.card = card
          callback(null, result)

module.exports = AcceptCardCommand
