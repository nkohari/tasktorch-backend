r               = require 'rethinkdb'
Team            = require 'data/documents/Team'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class AddMemberToTeamCommand extends Command

  constructor: (@requester, @team, @user) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Team, @team.id, {
      members: r.row('members').setInsert(@user.id)
    })
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      callback(null, team)

module.exports = AddMemberToTeamCommand
