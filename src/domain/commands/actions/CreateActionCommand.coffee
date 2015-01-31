Command                  = require 'domain/framework/Command'
ActionCreatedNote        = require 'data/documents/notes/ActionCreatedNote'
CreateActionStatement    = require 'data/statements/CreateActionStatement'
AddActionToCardStatement = require 'data/statements/AddActionToCardStatement'
CreateNoteStatement      = require 'data/statements/CreateNoteStatement'

class CreateActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    statement = new CreateActionStatement(@action)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      statement = new AddActionToCardStatement(action.id, action.card, action.stage, 'append')
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        note = ActionCreatedNote.create(@user, action)
        statement = new CreateNoteStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, action)

module.exports = CreateActionCommand
