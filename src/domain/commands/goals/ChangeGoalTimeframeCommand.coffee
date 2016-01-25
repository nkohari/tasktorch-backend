Command         = require 'domain/framework/Command'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeGoalTimeframeCommand extends Command

  constructor: (@user, @goal, @timeframe) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {@timeframe})
    conn.execute statement, (err, goal) =>
      return callback(err) if err?
      callback(null, goal)

module.exports = ChangeGoalTimeframeCommand
