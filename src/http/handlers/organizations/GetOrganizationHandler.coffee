Organization      = require 'data/entities/Organization'
GetQuery          = require 'data/queries/GetQuery'
OrganizationModel = require '../../models/OrganizationModel'
Handler           = require '../../framework/Handler'

class GetOrganizationHandler extends Handler

  @route 'get /organizations/{organizationId}'
  @demand 'is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organizationId} = request.params
    expand = request.query.expand?.split(',')
    query  = new GetQuery(Organization, organizationId, {expand})
    @database.execute query, (err, organization) =>
      return reply err if err?
      reply new OrganizationModel(organization)

module.exports = GetOrganizationHandler
