_     = require 'lodash'
r     = require 'rethinkdb'
Stack = require 'data/documents/Stack'
Query = require 'data/framework/queries/Query'

class GetSpecialStackByUserQuery extends Query

  constructor: (orgid, userid, type, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(userid, {index: 'user'})
      .filter({org: orgid, type: type})
      .limit(1)
      .coerceTo('array').do (result) ->
        r.branch(result.isEmpty(), null, result.nth(0))

module.exports = GetSpecialStackByUserQuery
