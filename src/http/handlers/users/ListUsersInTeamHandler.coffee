_                        = require 'lodash'
GetAllMembersOfTeamQuery = require 'data/queries/GetAllMembersOfTeamQuery'
Handler                  = require 'http/framework/Handler'

class ListUsersInTeamHandler extends Handler

  @route 'get /api/{organizationId}/teams/{teamId}/members'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query = new GetAllMembersOfTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, users) =>
      return reply err if err?
      models = _.map users, (user) => @modelFactory.create(user, request)
      reply(models)

module.exports = ListUsersInTeamHandler
