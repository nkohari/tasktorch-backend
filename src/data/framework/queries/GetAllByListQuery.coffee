r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class GetAllByListQuery extends Query

  constructor: (doctype, parentDoctype, parentId, property, options) ->
    super(doctype, options)

    table = @schema.table
    parentTable = parentDoctype.getSchema().table

    # TODO: Worried about the performance of this -- can we change it to use getAll() instead?
    @rql = r.table(parentTable).get(parentId)(property).default([]).map((id) ->
      r.table(table).get(id)
    ).default([]).coerceTo('array')

module.exports = GetAllByListQuery
