r               = require 'rethinkdb'
Checklist       = require 'data/documents/Checklist'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddActionToChecklistStatement extends UpdateStatement

  constructor: (checklistid, actionid, position) ->

    if position is 'prepend'
      arg = r.row('actions').prepend(actionid)
    else if position is 'append'
      arg = r.row('actions').append(actionid)
    else
      arg = r.row('actions').insertAt(position, actionid)

    super(Checklist, checklistid, {actions: arg})

module.exports = AddActionToChecklistStatement
