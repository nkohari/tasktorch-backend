r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Org   = require 'data/documents/Org'
User  = require 'data/documents/User'

class GetAllMembersByOrgQuery extends Query

  constructor: (orgid, options) ->
    super(User, options)
    @rql = r.table(@schema.table).getAll(
      r.args(r.table(Org.getSchema().table).get(orgid)('members'))
    ).coerceTo('array')

module.exports = GetAllMembersByOrgQuery
