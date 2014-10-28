_ = require 'lodash'
StackModel = require 'http/models/StackModel'
Handler = require 'http/framework/Handler'
GetAllStacksByOrganizationAndOwnerQuery = require 'data/queries/GetAllStacksByOrganizationAndOwnerQuery'

class ListMyStacksHandler extends Handler

  @route 'get /api/{organizationId}/my/stacks'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllStacksByOrganizationAndOwnerQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, teams) =>
      return reply err if err?
      reply _.map teams, (team) -> new StackModel(team, request)

module.exports = ListMyStacksHandler
