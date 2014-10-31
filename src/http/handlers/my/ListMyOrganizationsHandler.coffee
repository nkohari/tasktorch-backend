_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllOrganizationsByMemberQuery = require 'data/queries/GetAllOrganizationsByMemberQuery'

class ListMyOrganizationsHandler extends Handler

  @route 'get /api/my/organizations'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    query = new GetAllOrganizationsByMemberQuery(user.id, @getQueryOptions(request))
    @database.execute query, (err, organizations) =>
      return reply err if err?
      models = _.map organizations, (organization) => @modelFactory.create(organization, request)
      reply(models)

module.exports = ListMyOrganizationsHandler
