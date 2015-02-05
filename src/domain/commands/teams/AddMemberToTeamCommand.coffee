Command                  = require 'domain/framework/Command'
AddMemberToTeamStatement = require 'data/statements/AddMemberToTeamStatement'

class AddMemberToTeamCommand extends Command

  constructor: (@requester, @team, @user) ->

  execute: (conn, callback) ->
    statement = new AddMemberToTeamStatement(@team.id, @user.id)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = AddMemberToTeamCommand
