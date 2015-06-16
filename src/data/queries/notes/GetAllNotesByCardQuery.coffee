r     = require 'rethinkdb'
Note  = require 'data/documents/Note'
Query = require 'data/framework/queries/Query'

class GetAllNotesByCardQuery extends Query

  constructor: (cardid, options) ->
    super(Note, options)
    @rql = r.table(@schema.table).getAll(cardid, {index: 'card'}).orderBy('created').default([]).coerceTo('array')

module.exports = GetAllNotesByCardQuery
