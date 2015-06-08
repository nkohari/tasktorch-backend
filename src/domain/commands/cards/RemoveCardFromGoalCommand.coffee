r               = require 'rethinkdb'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class RemoveCardFromGoalCommand extends Command

  constructor: (@user, @goal, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {
      cards: r.row('cards').setDifference([@card.id])
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      callback(null, card)

module.exports = RemoveCardFromGoalCommand
