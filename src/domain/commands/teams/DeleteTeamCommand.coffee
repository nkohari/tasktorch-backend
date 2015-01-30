Command                       = require 'domain/framework/Command'
CommandResult                 = require 'domain/framework/CommandResult'
DeleteTeamStatement           = require 'data/statements/DeleteTeamStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class DeleteTeamCommand extends Command

  constructor: (@user, @team) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new DeleteTeamStatement(@team.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      result.messages.deleted(team)
      result.team = team
      callback(null, result)

module.exports = DeleteTeamCommand
