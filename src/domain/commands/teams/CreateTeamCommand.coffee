Command              = require 'domain/framework/Command'
CommandResult        = require 'domain/framework/CommandResult'
Stack                = require 'data/documents/Stack'
StackType            = require 'data/enums/StackType'
CreateTeamStatement  = require 'data/statements/CreateTeamStatement'
CreateStackStatement = require 'data/statements/CreateStackStatement'

class CreateTeamCommand extends Command

  constructor: (@user, @team) ->

  execute: (conn, callback) ->

    result = new CommandResult(@user)

    inbox = new Stack {
      org:  @team.org
      type: StackType.Inbox
      team: @team.id
    }

    statement = new CreateStackStatement(inbox)
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      result.messages.created(stack)
      statement = new CreateTeamStatement(@team)
      conn.execute statement, (err, team) =>
        return callback(err) if err?
        result.messages.created(team)
        result.team = team
        callback(null, result)

module.exports = CreateTeamCommand
