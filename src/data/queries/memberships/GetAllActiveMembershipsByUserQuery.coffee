r                = require 'rethinkdb'
Membership       = require 'data/documents/Membership'
MembershipStatus = require 'data/enums/MembershipStatus'
Query            = require 'data/framework/queries/Query'

class GetAllActiveMembershipsByUserQuery extends Query

  constructor: (userid, options) ->
    super(Membership, options)
    
    @rql = r.table(@schema.table)
      .getAll(userid, {index: 'user'})
      .filter(r.row('status').eq(MembershipStatus.Disabled).not())
      .coerceTo('array')

module.exports = GetAllActiveMembershipsByUserQuery
