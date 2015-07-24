r                   = require 'rethinkdb'
Card                = require 'data/documents/Card'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveAllCardsFromStageStatement extends BulkUpdateStatement

  constructor: (stageid) ->
    match = r.table(Card.getSchema().table).getAll(stageid, {index: 'stages'})
    patch = {stages: r.row('stages').setDifference([stageid])}
    super(Card, match, patch)

module.exports = RemoveAllCardsFromStageStatement
