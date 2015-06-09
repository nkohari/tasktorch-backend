r               = require 'rethinkdb'
Card            = require 'data/documents/Card'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class AddCardToGoalCommand extends Command

  constructor: (@user, @goal, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @card.id, {
      goals: r.row('goals').setInsert(@goal.id)
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      callback(null, card)

module.exports = AddCardToGoalCommand
