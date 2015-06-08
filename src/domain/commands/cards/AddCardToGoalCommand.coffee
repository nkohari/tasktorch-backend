r               = require 'rethinkdb'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class AddCardToGoalCommand extends Command

  constructor: (@user, @goal, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {
      cards: r.row('cards').setInsert(@card.id)
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      callback(null, card)

module.exports = AddCardToGoalCommand
