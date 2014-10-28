Handler = require 'http/framework/Handler'
OrganizationModel = require 'http/models/OrganizationModel'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'

class GetOrganizationHandler extends Handler

  @route 'get /api/{organizationId}'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organizationId} = request.params
    query = new GetOrganizationQuery(organizationId, @getQueryOptions(request))
    @database.execute query, (err, organization) =>
      return reply err if err?
      reply new OrganizationModel(organization, request)

module.exports = GetOrganizationHandler
