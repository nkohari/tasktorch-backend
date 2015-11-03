_                = require 'lodash'
r                = require 'rethinkdb'
Membership       = require 'data/documents/Membership'
MembershipStatus = require 'data/enums/MembershipStatus'
Query            = require 'data/framework/queries/Query'

class GetAllActiveMembershipsByOrgQuery extends Query

  constructor: (orgids, options) ->
    super(Membership, options)
    
    orgids = _.flatten [orgids]
    @rql = r.table(@schema.table)
      .getAll(r.args(orgids), {index: 'org'})
      .filter(r.row('status').eq(MembershipStatus.Disabled).not())
      .coerceTo('array')

module.exports = GetAllActiveMembershipsByOrgQuery
