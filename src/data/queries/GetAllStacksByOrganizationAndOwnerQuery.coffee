r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetAllStacksByOrganizationAndOwnerQuery extends Query

  constructor: (organizationId, userId, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(userId, {index: 'owner'})
      .filter({organization: organizationId})

module.exports = GetAllStacksByOrganizationAndOwnerQuery
