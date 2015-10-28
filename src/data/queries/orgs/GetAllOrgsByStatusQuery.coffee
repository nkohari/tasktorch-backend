r     = require 'rethinkdb'
Org   = require 'data/documents/Org'
Query = require 'data/framework/queries/Query'

class GetAllOrgsByStatusQuery extends Query

  constructor: (status) ->
    super(Org, {allowDeleted: true})
    @rql = r.table(Org.getSchema().table).filter({status})

module.exports = GetAllOrgsByStatusQuery
