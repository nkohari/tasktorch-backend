Handler = require 'http/framework/Handler'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'

class GetOrganizationHandler extends Handler

  @route 'get /api/{organizationId}'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organizationId} = request.params
    query = new GetOrganizationQuery(organizationId, @getQueryOptions(request))
    @database.execute query, (err, organization) =>
      return reply err if err?
      model = @modelFactory.create(organization, reply)
      reply(model).etag(model.version)

module.exports = GetOrganizationHandler
