Command                            = require 'domain/framework/Command'
ActionCreatedNote                  = require 'data/documents/notes/ActionCreatedNote'
AddActionToChecklistStatement      = require 'data/statements/AddActionToChecklistStatement'
UpdateCardStagesAndStatusStatement = require 'data/statements/UpdateCardStagesAndStatusStatement'
CreateStatement                    = require 'data/statements/CreateStatement'

class CreateActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      statement = new AddActionToChecklistStatement(action.checklist, action.id, 'append')
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new UpdateCardStagesAndStatusStatement(action.card)
        conn.execute statement, (err) =>
          return callback(err) if err?
          note = ActionCreatedNote.create(@user, action)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, action)

module.exports = CreateActionCommand
