Command             = require 'domain/framework/Command'
UpdateTeamStatement = require 'data/statements/UpdateTeamStatement'

class ChangeTeamNameCommand extends Command

  constructor: (@user, @team, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateTeamStatement(@team.id, {@name})
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = ChangeTeamNameCommand
