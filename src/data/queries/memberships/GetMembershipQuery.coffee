Membership = require 'data/documents/Membership'
GetQuery   = require 'data/framework/queries/GetQuery'

class GetMembershipQuery extends GetQuery

  constructor: (id, options) ->
    super(Membership, id, options)

module.exports = GetMembershipQuery
