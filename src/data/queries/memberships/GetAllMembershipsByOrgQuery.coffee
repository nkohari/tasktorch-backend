Membership         = require 'data/documents/Membership'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllMembershipsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgid, options) ->
    super(Membership, {org: orgid}, options)

module.exports = GetAllMembershipsByOrgQuery
