Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateCardStatement = require 'data/statements/UpdateCardStatement'

class ChangeCardTitleCommand extends Command

  constructor: (@cardId, @title) ->
    super()

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateCardStatement(@cardId, {title: @title})
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.changed(card)
      result.card = card
      callback(null, result)

module.exports = ChangeCardTitleCommand
