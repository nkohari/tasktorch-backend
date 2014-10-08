_          = require 'lodash'
{Type}     = require 'data/entities'
OrganizationModel = require '../../models/OrganizationModel'
StackModel = require '../../models/StackModel'
TeamModel  = require '../../models/TeamModel'
TypeModel  = require '../../models/TypeModel'
UserModel  = require '../../models/UserModel'
Handler    = require '../../framework/Handler'
{GetAllByQuery, GetAllTeamsByOrganizationAndMemberQuery, GetAllStacksByOrganizationAndOwnerQuery} = require 'data/queries'

class GetMyWorkspaceHandler extends Handler

  @route 'get /api/{organizationId}/my/workspace'
  @demand 'requester is organization member'

  constructor: (@log, @database) ->

  handle: (request, reply) ->

    {user}         = request.auth.credentials
    {organization} = request.scope

    @database.executeAll [
      new GetAllByQuery(Type, {organization: organization.id})
      new GetAllTeamsByOrganizationAndMemberQuery(organization, user, {expand: 'stacks'})
      new GetAllStacksByOrganizationAndOwnerQuery(organization, user)
    ], (err, [types, teams, stacks]) =>
      return reply err if err?
      
      reply {
        user:         new UserModel(user)
        organization: new OrganizationModel(organization)
        types:        _.map(types, (type) -> new TypeModel(request.baseUrl, type))
        teams:        _.map(teams, (team) -> new TeamModel(request.baseUrl, team))
        stacks:       _.map(stacks, (stack) -> new StackModel(request.baseUrl, stack))
      }

module.exports = GetMyWorkspaceHandler
