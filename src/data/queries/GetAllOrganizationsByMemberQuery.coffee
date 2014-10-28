Organization = require 'data/schemas/Organization'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllOrganizationsByMemberQuery extends GetAllByIndexQuery

  constructor: (userId, options) ->
    super(Organization, {members: userId}, options)

module.exports = GetAllOrganizationsByMemberQuery
