Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
RemoveMemberFromTeamStatement = require 'data/statements/RemoveMemberFromTeamStatement'

class RemoveMemberFromTeamCommand extends Command

  constructor: (@user, @team, @member) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveMemberFromTeamStatement(@team.id, @member.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      result.messages.changed(team)
      result.team = team
      callback(null, result)

module.exports = RemoveMemberFromTeamCommand
