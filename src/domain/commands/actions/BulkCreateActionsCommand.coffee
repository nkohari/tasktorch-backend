async                              = require 'async'
Command                            = require 'domain/framework/Command'
ActionCreatedNote                  = require 'data/documents/notes/ActionCreatedNote'
AddActionToChecklistStatement      = require 'data/statements/AddActionToChecklistStatement'
UpdateCardStagesAndStatusStatement = require 'data/statements/UpdateCardStagesAndStatusStatement'
CreateStatement                    = require 'data/statements/CreateStatement'
BulkCreateStatement                = require 'data/statements/BulkCreateStatement'
Action                             = require 'data/documents/Action'

class BulkCreateActionsCommand extends Command

  constructor: (@user, @card, @actions) ->

  execute: (conn, callback) ->
    statement = new BulkCreateStatement(Action, @actions)
    conn.execute statement, (err, actions) =>
      return callback(err) if err?

      addActionToChecklistAndCreateNote = (action, next) =>
        statement = new AddActionToChecklistStatement(action.checklist, action.id, 'append')
        conn.execute statement, (err) =>
          return next(err) if err?
          note = ActionCreatedNote.create(@user, action)
          statement = new CreateStatement(note)
          conn.execute(statement, next)

      async.eachSeries actions, addActionToChecklistAndCreateNote, (err) =>
        return callback(err) if err?
        statement = new UpdateCardStagesAndStatusStatement(@card.id)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, actions)

module.exports = BulkCreateActionsCommand
