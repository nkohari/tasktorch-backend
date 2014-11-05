_        = require 'lodash'
r        = require 'rethinkdb'
Stack    = require 'data/schemas/Stack'
Document = require 'data/framework/Document'
Query    = require 'data/framework/queries/Query'

class GetSpecialStackByOrganizationAndOwnerQuery extends Query

  constructor: (organizationId, userId, kind, options) ->
    super(Stack, _.extend({firstResult: true}, options))
    console.log(options.expand)
    @rql = r.table(Stack.table).getAll(userId, {index: 'owner'})
      .filter({organization: organizationId, kind: kind})
      .limit(1)

module.exports = GetSpecialStackByOrganizationAndOwnerQuery
