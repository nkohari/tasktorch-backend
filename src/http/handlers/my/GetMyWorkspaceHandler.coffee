_ = require 'lodash'
Handler = require 'http/framework/Handler'
OrganizationModel = require 'http/models/OrganizationModel'
StackModel = require 'http/models/StackModel'
TeamModel = require 'http/models/TeamModel'
TypeModel = require 'http/models/TypeModel'
UserModel = require 'http/models/UserModel'
GetAllTypesByOrganizationQuery = require 'data/queries/GetAllTypesByOrganizationQuery'
GetAllTeamsByOrganizationAndMemberQuery = require 'data/queries/GetAllTeamsByOrganizationAndMemberQuery'
GetAllStacksByOrganizationAndOwnerQuery = require 'data/queries/GetAllStacksByOrganizationAndOwnerQuery'

class GetMyWorkspaceHandler extends Handler

  @route 'get /api/{organizationId}/my/workspace'
  @demand 'requester is organization member'

  constructor: (@log, @database) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {organization} = request.scope

    @database.executeAll [
      new GetAllTypesByOrganizationQuery(organization.id)
      new GetAllTeamsByOrganizationAndMemberQuery(organization.id, user.id, {expand: 'stacks'})
      new GetAllStacksByOrganizationAndOwnerQuery(organization.id, user.id)
    ], (err, [types, teams, stacks]) =>
      console.log(arguments)
      return reply err if err?
      
      reply {
        user:         new UserModel(user, request)
        organization: new OrganizationModel(organization, request)
        types:        _.map(types, (type) -> new TypeModel(type, request))
        teams:        _.map(teams, (team) -> new TeamModel(team, request))
        stacks:       _.map(stacks, (stack) -> new StackModel(stack, request))
      }

module.exports = GetMyWorkspaceHandler
