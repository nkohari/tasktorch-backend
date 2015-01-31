Command                  = require 'domain/framework/Command'
AddMemberToTeamStatement = require 'data/statements/AddMemberToTeamStatement'

class AddMemberToTeamCommand extends Command

  constructor: (@user, @team, @member) ->

  execute: (conn, callback) ->
    statement = new AddMemberToTeamStatement(@team.id, @member.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = AddMemberToTeamCommand
