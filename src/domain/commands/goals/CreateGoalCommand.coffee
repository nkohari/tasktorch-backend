CreateStatement = require 'data/statements/CreateStatement'
Command         = require 'domain/framework/Command'

class CreateGoalCommand extends Command

  constructor: (@user, @goal) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@goal)
    conn.execute statement, (err, goal) =>
      return callback(err) if err?
      callback(null, goal)

module.exports = CreateGoalCommand
