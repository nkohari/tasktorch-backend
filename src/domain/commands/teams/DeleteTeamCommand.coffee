Command                       = require 'domain/framework/Command'
DeleteTeamStatement           = require 'data/statements/DeleteTeamStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class DeleteTeamCommand extends Command

  constructor: (@user, @team) ->

  execute: (conn, callback) ->
    statement = new DeleteTeamStatement(@team.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = DeleteTeamCommand
