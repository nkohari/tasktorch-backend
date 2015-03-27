r               = require 'rethinkdb'
Checklist       = require 'data/documents/Checklist'
UpdateStatement = require 'data/statements/UpdateStatement'

class RepositionActionInChecklistStatement extends UpdateStatement

  constructor: (checklist, actionid, position) ->

    arg = r.row('actions').difference([actionid])

    if position is 'prepend'
      arg = arg.prepend(actionid)
    else if position is 'append'
      arg = arg.append(actionid)
    else
      arg = arg.insertAt(position, actionid)

    super(Checklist, checklist, {actions: arg})

module.exports = RepositionActionInChecklistStatement
