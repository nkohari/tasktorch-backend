r            = require 'rethinkdb'
{Team}       = require '../entities'
ExpandoQuery = require '../framework/ExpandoQuery'

class GetAllTeamsByOrganizationAndMemberQuery extends ExpandoQuery

  constructor: (organization, user, options) ->
    super(Team, options)
    @rql = r.table(Team.schema.table).getAll(user.id, {index: 'members'})
      .filter({organization: organization.id})

module.exports = GetAllTeamsByOrganizationAndMemberQuery
