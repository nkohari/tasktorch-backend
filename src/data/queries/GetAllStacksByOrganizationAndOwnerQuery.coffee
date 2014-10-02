r            = require 'rethinkdb'
{Stack}      = require '../entities'
ExpandoQuery = require '../framework/ExpandoQuery'

class GetAllStacksByOrganizationAndOwnerQuery extends ExpandoQuery

  constructor: (organization, user, options) ->
    super(Stack, options)
    @rql = r.table(Stack.schema.table).getAll(user.id, {index: 'owner'})
      .filter({organization: organization.id})

module.exports = GetAllStacksByOrganizationAndOwnerQuery
