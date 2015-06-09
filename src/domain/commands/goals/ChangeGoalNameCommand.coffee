Command         = require 'domain/framework/Command'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeGoalNameCommand extends Command

  constructor: (@user, @goal, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {@name})
    conn.execute statement, (err, goal) =>
      return callback(err) if err?
      callback(null, goal)

module.exports = ChangeGoalNameCommand
