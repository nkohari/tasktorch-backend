Command                       = require 'domain/framework/Command'
DeleteStatement               = require 'data/statements/DeleteStatement'
RemoveCardFromStacksStatement = require 'data/statements/RemoveCardFromStacksStatement'

class DeleteTeamCommand extends Command

  constructor: (@user, @team) ->

  execute: (conn, callback) ->
    statement = new DeleteStatement(@team)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = DeleteTeamCommand
