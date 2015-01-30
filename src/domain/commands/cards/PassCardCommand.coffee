r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
CardPassedNote                = require 'data/documents/notes/CardPassedNote'
Move                          = require 'data/structs/Move'
MoveType                      = require 'data/enums/MoveType'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
AddCardToStackStatement       = require 'data/statements/AddCardToStackStatement'
UpdateCardStatement           = require 'data/statements/UpdateCardStatement'

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
          result.addNote(CardPassedNote.create(@user, card, previous))
          result.card = card
          callback(null, result)

module.exports = PassCardCommand
