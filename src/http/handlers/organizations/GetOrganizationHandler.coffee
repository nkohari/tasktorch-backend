OrganizationModel = require '../../models/OrganizationModel'
Handler           = require '../../framework/Handler'

class GetOrganizationHandler extends Handler

  @route 'get /organizations/{organizationId}'
  @demand 'is organization member'
  
  constructor: (log, @organizationService) ->
    super(log)

  handle: (request, reply) ->
    {organizationId} = request.params
    expand = request.query.expand.split(',') if request.query.expand?.length > 0
    @organizationService.get organizationId, {expand}, (err, organization) =>
      return reply @error(err) if err?
      return reply @notFound() unless organization?
      reply new OrganizationModel(organization)

module.exports = GetOrganizationHandler
