r     = require 'rethinkdb'
Note  = require 'data/schemas/Note'
Query = require 'data/framework/queries/Query'

class GetAllNotesByCardQuery extends Query

  constructor: (cardId, options) ->
    super(Note, options)
    @rql = r.table(Note.table).getAll(cardId, {index: 'card'}).orderBy('time').default([]).coerceTo('array')

module.exports = GetAllNotesByCardQuery
