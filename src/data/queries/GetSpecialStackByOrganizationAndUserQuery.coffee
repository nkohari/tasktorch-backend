_     = require 'lodash'
r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetSpecialStackByOrganizationAndUserQuery extends Query

  constructor: (organizationId, userId, type, options) ->
    super(Stack, _.extend({firstResult: true}, options))
    @rql = r.table(Stack.table).getAll(userId, {index: 'owner'})
      .filter({organization: organizationId, type: type})
      .limit(1)

module.exports = GetSpecialStackByOrganizationAndUserQuery
