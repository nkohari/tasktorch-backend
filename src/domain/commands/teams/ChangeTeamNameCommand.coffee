Command         = require 'domain/framework/Command'
Team            = require 'data/documents/Team'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeTeamNameCommand extends Command

  constructor: (@user, @team, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Team, @team.id, {@name})
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = ChangeTeamNameCommand
