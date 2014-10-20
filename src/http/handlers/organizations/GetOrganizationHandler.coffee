{Organization}    = require 'data/entities'
{GetQuery}        = require 'data/queries'
OrganizationModel = require '../../models/OrganizationModel'
Handler           = require '../../framework/Handler'

class GetOrganizationHandler extends Handler

  @route 'get /api/{organizationId}'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organizationId} = request.params
    expand = request.query.expand?.split(',')
    query  = new GetQuery(Organization, organizationId, {expand})
    @database.execute query, (err, organization) =>
      return reply err if err?
      reply new OrganizationModel(organization, request)

module.exports = GetOrganizationHandler
