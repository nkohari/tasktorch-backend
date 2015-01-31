Command                       = require 'domain/framework/Command'
RemoveMemberFromTeamStatement = require 'data/statements/RemoveMemberFromTeamStatement'

class RemoveMemberFromTeamCommand extends Command

  constructor: (@user, @team, @member) ->

  execute: (conn, callback) ->
    statement = new RemoveMemberFromTeamStatement(@team.id, @member.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = RemoveMemberFromTeamCommand
