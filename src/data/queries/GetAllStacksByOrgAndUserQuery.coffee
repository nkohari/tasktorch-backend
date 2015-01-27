r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetAllStacksByOrgAndUserQuery extends Query

  constructor: (orgId, userId, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(userId, {index: 'user'})
      .filter({org: orgId})
      .coerceTo('array')

module.exports = GetAllStacksByOrgAndUserQuery
