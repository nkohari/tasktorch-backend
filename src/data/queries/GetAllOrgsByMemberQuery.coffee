Org                = require 'data/schemas/Org'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllOrgsByMemberQuery extends GetAllByIndexQuery

  constructor: (userId, options) ->
    super(Org, {members: userId}, options)

module.exports = GetAllOrgsByMemberQuery
