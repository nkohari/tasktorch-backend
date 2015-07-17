Command                              = require 'domain/framework/Command'
Action                               = require 'data/documents/Action'
ActionStatus                         = require 'data/enums/ActionStatus'
ActionStatusChangedNote              = require 'data/documents/notes/ActionStatusChangedNote'
CreateStatement                      = require 'data/statements/CreateStatement'
UpdateStatement                      = require 'data/statements/UpdateStatement'
UpdateCardStatusFromActionsStatement = require 'data/statements/UpdateCardStatusFromActionsStatement'

class ChangeActionStatusCommand extends Command

  constructor: (@user, @action, @status) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Action, @action.id, {
      status:    @status
      user:      @user.id
      completed: if @status == ActionStatus.Complete then new Date() else null
    })
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      statement = new UpdateCardStatusFromActionsStatement(@action.card)
      conn.execute statement, (err) =>
        return callback(err) if err?
        note = ActionStatusChangedNote.create(@user, action, previous)
        statement = new CreateStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, action)

module.exports = ChangeActionStatusCommand
