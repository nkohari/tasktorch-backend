r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Org   = require 'data/schemas/Org'
User  = require 'data/schemas/User'

class GetAllMembersByOrgQuery extends Query

  constructor: (orgid, options) ->
    super(User, options)
    @rql = r.table(User.table).getAll(
      r.args(r.table(Org.table).get(orgid)('members'))
    ).coerceTo('array')

module.exports = GetAllMembersByOrgQuery
