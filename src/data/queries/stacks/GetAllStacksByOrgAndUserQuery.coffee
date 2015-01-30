r     = require 'rethinkdb'
Stack = require 'data/documents/Stack'
Query = require 'data/framework/queries/Query'

class GetAllStacksByOrgAndUserQuery extends Query

  constructor: (orgid, userid, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(userid, {index: 'user'})
      .filter({org: orgid})
      .coerceTo('array')

module.exports = GetAllStacksByOrgAndUserQuery
