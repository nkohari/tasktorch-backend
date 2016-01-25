Command         = require 'domain/framework/Command'
Goal            = require 'data/documents/Goal'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeGoalDescriptionCommand extends Command

  constructor: (@user, @goal, @description) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Goal, @goal.id, {@description})
    conn.execute statement, (err, goal) =>
      return callback(err) if err?
      callback(null, goal)

module.exports = ChangeGoalDescriptionCommand
