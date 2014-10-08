_                 = require 'lodash'
{Organization}    = require 'data/entities'
OrganizationModel = require '../../models/OrganizationModel'
Handler           = require '../../framework/Handler'
{GetAllByQuery}   = require 'data/queries'

class ListMyOrganizationsHandler extends Handler

  @route 'get /api/my/organizations'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    expand = request.query.expand?.split(',')
    query = new GetAllByQuery(Organization, {members: user.id}, {expand})
    @database.execute query, (err, organizations) =>
      return reply err if err?
      reply _.map organizations, (organization) -> new OrganizationModel(organization)

module.exports = ListMyOrganizationsHandler
