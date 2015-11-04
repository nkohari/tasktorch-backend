r                = require 'rethinkdb'
Query            = require 'data/framework/queries/Query'
Membership       = require 'data/documents/Membership'
User             = require 'data/documents/User'
MembershipStatus = require 'data/enums/MembershipStatus'

class GetAllUsersByOrgQuery extends Query

  constructor: (orgid, options) ->
    super(User, options)

    userids = r.table(Membership.getSchema().table)
      .getAll(orgid, {index: 'org'})
      .filter({status: MembershipStatus.Normal})
      .default([])
      .coerceTo('array')('user')

    @rql = r.table(@schema.table).getAll(r.args(userids)).coerceTo('array')

module.exports = GetAllUsersByOrgQuery
