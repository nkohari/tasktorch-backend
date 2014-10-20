_          = require 'lodash'
{Stack}    = require 'data/entities'
StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'
{GetAllStacksByOrganizationAndOwnerQuery} = require 'data/queries'

class ListMyStacksHandler extends Handler

  @route 'get /api/{organizationId}/my/stacks'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    expand = request.query.expand?.split(',')
    query = new GetAllStacksByOrganizationAndOwnerQuery(organization, user, {expand})
    @database.execute query, (err, teams) =>
      return reply err if err?
      reply _.map teams, (team) -> new StackModel(team, request)

module.exports = ListMyStacksHandler
