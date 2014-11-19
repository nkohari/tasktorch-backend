_                                = require 'lodash'
FindMembersOfOrganizationQuery   = require 'data/queries/FindMembersOfOrganizationQuery'
GetAllMembersOfOrganizationQuery = require 'data/queries/GetAllMembersOfOrganizationQuery'
Handler                          = require 'http/framework/Handler'

class ListMembersOfOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/members'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    options = @getQueryOptions(request)

    if request.query.suggest?
      query = new FindMembersOfOrganizationQuery(organization.id, request.query.suggest, options)
    else
      query = new GetAllMembersOfOrganizationQuery(organization.id, options)

    @database.execute query, (err, users) =>
      return reply err if err?
      models = _.map users, (user) => @modelFactory.create(user, request)
      reply(models)

module.exports = ListMembersOfOrganizationHandler
