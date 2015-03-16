_                   = require 'lodash'
Checklist           = require 'data/documents/Checklist'
BulkCreateStatement = require 'data/statements/BulkCreateStatement'

class CreateChecklistsForCardStatement extends BulkCreateStatement

  constructor: (orgid, cardid, stageids) ->
    checklists = _.map stageids, (stageid) ->
      new Checklist {org: orgid, card: cardid, stage: stageid}
    super(Checklist, checklists)

module.exports = CreateChecklistsForCardStatement
