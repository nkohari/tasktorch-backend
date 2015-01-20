r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
Move                          = require 'domain/documents/Move'
MoveType                      = require 'domain/enums/MoveType'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

class PassCardCommand extends Command

  constructor: (@user, @cardId, @stackId, @ownerId) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@cardId)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.messages.changed(previousStacks)
      statement = new AddCardToStackStatement(@stackId, @cardId, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        move = new Move(@user, previousStacks[0], currentStack)
        statement = new UpdateCardStatement(@cardId, {
          stack: @stackId
          owner: @ownerId
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previousCard) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.card = card
          callback(null, result)

module.exports = PassCardCommand
