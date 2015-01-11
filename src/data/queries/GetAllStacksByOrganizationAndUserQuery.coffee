r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetAllStacksByOrganizationAndUserQuery extends Query

  constructor: (organizationId, userId, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(userId, {index: 'user'})
      .filter({organization: organizationId})
      .coerceTo('array')

module.exports = GetAllStacksByOrganizationAndUserQuery
