r                = require 'rethinkdb'
Query            = require 'data/framework/queries/Query'
Membership       = require 'data/documents/Membership'
Org              = require 'data/documents/Org'
MembershipStatus = require 'data/enums/MembershipStatus'

class GetAllOrgsByUserQuery extends Query

  constructor: (userid, options) ->
    super(Org, options)
    @rql = r.table(@schema.table).getAll(
      r.args(r.table(Membership.getSchema().table).getAll(userid, {index: 'user'}).filter({status: MembershipStatus.Normal})('user'))
    ).coerceTo('array')

module.exports = GetAllOrgsByUserQuery
