Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateCardStatement = require 'data/statements/UpdateCardStatement'

class ChangeCardBodyCommand extends Command

  constructor: (@cardId, @body) ->
    super()

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateCardStatement(@cardId, {body: @body})
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      result.changed(card)
      result.card = card
      callback(null, result)

module.exports = ChangeCardBodyCommand
