r            = require 'rethinkdb'
Query        = require 'data/framework/queries/Query'
Organization = require 'data/schemas/Organization'
User         = require 'data/schemas/User'

class GetAllMembersOfOrganizationQuery extends Query

  constructor: (organizationId, options) ->
    super(User, options)
    @rql = r.table(User.table).getAll(
      r.args(r.table(Organization.table).get(organizationId)('members'))
    )

module.exports = GetAllMembersOfOrganizationQuery
