_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllTypesByOrganizationQuery = require 'data/queries/GetAllTypesByOrganizationQuery'
GetAllTeamsByOrganizationAndMemberQuery = require 'data/queries/GetAllTeamsByOrganizationAndMemberQuery'
GetAllStacksByOrganizationAndOwnerQuery = require 'data/queries/GetAllStacksByOrganizationAndOwnerQuery'

class GetMyWorkspaceHandler extends Handler

  @route 'get /api/{organizationId}/my/workspace'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {organization} = request.scope

    @database.executeAll [
      new GetAllTypesByOrganizationQuery(organization.id)
      new GetAllTeamsByOrganizationAndMemberQuery(organization.id, user.id, {expand: 'stacks'})
      new GetAllStacksByOrganizationAndOwnerQuery(organization.id, user.id)
    ], (err, [types, teams, stacks]) =>
      return reply err if err?
      reply {
        user:         @modelFactory.create(user, request)
        organization: @modelFactory.create(organization, request)
        types:        _.map(types, (type) => @modelFactory.create(type, request))
        teams:        _.map(teams, (team) => @modelFactory.create(team, request))
        stacks:       _.map(stacks, (stack) => @modelFactory.create(stack, request))
      }

module.exports = GetMyWorkspaceHandler
