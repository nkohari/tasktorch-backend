r                = require 'rethinkdb'
Query            = require 'data/framework/queries/Query'
Membership       = require 'data/documents/Membership'
Org              = require 'data/documents/Org'
MembershipStatus = require 'data/enums/MembershipStatus'

class GetAllOrgsByUserQuery extends Query

  constructor: (userid, options) ->
    super(Org, options)

    @rql = r.table(Membership.getSchema().table).getAll(userid, {index: 'user'})
      .filter({status: MembershipStatus.Normal})
      .eqJoin('org', r.table(@schema.table))('right')
      .coerceTo('array')

module.exports = GetAllOrgsByUserQuery
