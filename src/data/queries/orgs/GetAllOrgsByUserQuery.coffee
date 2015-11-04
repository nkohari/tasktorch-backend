r                = require 'rethinkdb'
Query            = require 'data/framework/queries/Query'
Membership       = require 'data/documents/Membership'
Org              = require 'data/documents/Org'
MembershipStatus = require 'data/enums/MembershipStatus'

class GetAllOrgsByUserQuery extends Query

  constructor: (userid, options) ->
    super(Org, options)

    orgids = r.table(Membership.getSchema().table)
      .getAll(userid, {index: 'user'})
      .filter({status: MembershipStatus.Normal})
      .default([])
      .coerceTo('array')('org')

    @rql = r.table(@schema.table).getAll(r.args(orgids)).coerceTo('array')

module.exports = GetAllOrgsByUserQuery
