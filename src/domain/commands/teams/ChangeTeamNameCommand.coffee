Command             = require 'domain/framework/Command'
CommandResult       = require 'domain/framework/CommandResult'
UpdateTeamStatement = require 'data/statements/UpdateTeamStatement'

class ChangeTeamNameCommand extends Command

  constructor: (@user, @team, @name) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateTeamStatement(@team.id, {@name})
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      result.messages.changed(team)
      result.team = team
      callback(null, result)

module.exports = ChangeTeamNameCommand
