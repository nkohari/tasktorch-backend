Command         = require 'domain/framework/Command'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeGoalStatusCommand extends Command

  constructor: (@user, @goal, @status) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {@status})
    conn.execute statement, (err, goal) =>
      return callback(err) if err?
      callback(null, goal)

module.exports = ChangeGoalStatusCommand
