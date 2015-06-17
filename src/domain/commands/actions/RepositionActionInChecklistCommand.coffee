Command                              = require 'domain/framework/Command'
RepositionActionInChecklistStatement = require 'data/statements/RepositionActionInChecklistStatement'

class RepositionActionInChecklistCommand extends Command

  constructor: (@user, @actionid, @checklistid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RepositionActionInChecklistStatement(@checklistid, @actionid, @position)
    conn.execute statement, (err, checklist) =>
      return callback(err) if err?
      callback(null, checklist)

module.exports = RepositionActionInChecklistCommand
