Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
DeleteTeamStatement           = require 'data/statements/DeleteTeamStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'
CardDeletedNote               = require 'domain/documents/notes/CardDeletedNote'

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
