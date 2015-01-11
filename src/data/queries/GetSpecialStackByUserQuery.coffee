_     = require 'lodash'
r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetSpecialStackByUserQuery extends Query

  constructor: (organizationId, userId, type, options) ->
    super(Stack, options)
    @rql = r.table(Stack.table).getAll(userId, {index: 'user'})
      .filter({organization: organizationId, type: type})
      .limit(1)
      .coerceTo('array').do (result) ->
        r.branch(result.isEmpty(), null, result.nth(0))

module.exports = GetSpecialStackByUserQuery
