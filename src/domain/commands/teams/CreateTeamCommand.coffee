Command         = require 'domain/framework/Command'
Stack           = require 'data/documents/Stack'
StackType       = require 'data/enums/StackType'
CreateStatement = require 'data/statements/CreateStatement'

class CreateTeamCommand extends Command

  constructor: (@user, @team) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@team)
    conn.execute statement, (err, team) =>
      return callback(err) if err?
      inbox = new Stack {
        org:  @team.org
        type: StackType.Inbox
        team: @team.id
      }
      statement = new CreateStatement(inbox)
      conn.execute statement, (err, stack) =>
        return callback(err) if err?
        callback(null, team)

module.exports = CreateTeamCommand
