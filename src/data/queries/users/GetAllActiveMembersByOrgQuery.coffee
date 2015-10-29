r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Event = require 'data/documents/Event'
User  = require 'data/documents/User'

MAX_AGE = 1000 * 60 * 60 * 24 * 30 # 30 days

class GetAllActiveMembersByOrgQuery extends Query

  constructor: (orgid, options) ->
    super(User, options)
    @rql = r.table(Event.getSchema().table).getAll(orgid, {index: 'org'})
      .filter(r.row('created').gt(r.now().sub(MAX_AGE)))('user').distinct().coerceTo('array')
      .do (ids) =>
        r.branch(
          ids.eq([]),
          [],
          r.table(@schema.table).getAll(r.args(ids)).coerceTo('array')
        )

module.exports = GetAllActiveMembersByOrgQuery
