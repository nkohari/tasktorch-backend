r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
Move                          = require 'domain/documents/Move'
MoveType                      = require 'domain/enums/MoveType'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'
CardPassedNote                = require 'domain/documents/notes/CardPassedNote'

class PassCardCommand extends Command

  constructor: (@user, @card, @stack) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveCardFromStacksStatement(@card.id)
    conn.execute statement, (err, previousStacks) =>
      return callback(err) if err?
      result.messages.changed(previousStacks)
      statement = new AddCardToStackStatement(@stack.id, @card.id, 'append')
      conn.execute statement, (err, currentStack) =>
        return callback(err) if err?
        result.messages.changed(currentStack)
        move = new Move(@user, previousStacks[0], currentStack)
        statement = new UpdateCardStatement(@card.id, {
          stack: currentStack.id
          owner: currentStack.owner ? null
          moves: r.row('moves').append(move)
        })
        conn.execute statement, (err, card, previous) =>
          return callback(err) if err?
          result.messages.changed(card)
          result.addNote(new CardPassedNote(@user, card, previous))
          result.card = card
          callback(null, result)

module.exports = PassCardCommand
