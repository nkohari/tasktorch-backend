Org                = require 'data/documents/Org'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllOrgsByMemberQuery extends GetAllByIndexQuery

  constructor: (userid, options) ->
    super(Org, {members: userid}, options)

module.exports = GetAllOrgsByMemberQuery
