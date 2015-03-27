Command                        = require 'domain/framework/Command'
RepositionCardInStackStatement = require 'data/statements/RepositionCardInStackStatement'

class RepositionCardInStackCommand extends Command

  constructor: (@user, @cardid, @stackid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RepositionCardInStackStatement(@stackid, @cardid, @position)
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = RepositionCardInStackCommand
