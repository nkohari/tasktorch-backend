Command                         = require 'domain/framework/Command'
Goal                            = require 'data/documents/Goal'
GoalStatus                      = require 'data/enums/GoalStatus'
RemoveAllCardsFromGoalStatement = require 'data/statements/RemoveAllCardsFromGoalStatement'
UpdateStatement                 = require 'data/statements/UpdateStatement'

class ChangeGoalNameCommand extends Command

  constructor: (@user, @goal, @name) ->

  execute: (conn, callback) ->
    statement = new RemoveAllCardsFromGoalStatement(@goal.id)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new UpdateStatement(Goal, @goal.id, {status: GoalStatus.Deleted})
      conn.execute statement, (err, goal) =>
        return callback(err) if err?
        callback(null, goal)

module.exports = ChangeGoalNameCommand
