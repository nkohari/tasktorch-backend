_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllStacksByOrganizationAndOwnerQuery = require 'data/queries/GetAllStacksByOrganizationAndOwnerQuery'

class ListMyStacksHandler extends Handler

  @route 'get /api/{organizationId}/me/stacks'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllStacksByOrganizationAndOwnerQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, stacks) =>
      return reply err if err?
      models = _.map stacks, (stack) => @modelFactory.create(stack, request)
      reply(models)

module.exports = ListMyStacksHandler
