_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllKindsByOrganizationQuery = require 'data/queries/GetAllKindsByOrganizationQuery'

class ListKindsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/kinds'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    query = new GetAllKindsByOrganizationQuery(organization.id, @getQueryOptions(request))
    @database.execute query, (err, kinds) =>
      return reply err if err?
      models = _.map kinds, (kind) => @modelFactory.create(kind, request)
      reply(models)

module.exports = ListKindsInOrganizationHandler
