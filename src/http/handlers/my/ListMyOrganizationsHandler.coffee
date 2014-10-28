_ = require 'lodash'
OrganizationModel = require 'http/models/OrganizationModel'
Handler = require 'http/framework/Handler'
GetAllOrganizationsByMemberQuery = require 'data/queries/GetAllOrganizationsByMemberQuery'

class ListMyOrganizationsHandler extends Handler

  @route 'get /api/my/organizations'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    query = new GetAllOrganizationsByMemberQuery(user.id, @getQueryOptions(request))
    @database.execute query, (err, organizations) =>
      return reply err if err?
      reply _.map organizations, (organization) -> new OrganizationModel(organization, request)

module.exports = ListMyOrganizationsHandler
