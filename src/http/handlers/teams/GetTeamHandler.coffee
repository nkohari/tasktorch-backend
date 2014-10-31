Handler = require 'http/framework/Handler'
GetTeamQuery = require 'data/queries/GetTeamQuery'

class GetTeamHandler extends Handler

  @route 'get /api/{organizationId}/teams/{teamId}'
  @demand ['requester is organization member', 'team belongs to organization']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query = new GetTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, team) =>
      return reply err if err?
      model = @modelFactory.create(team, request)
      reply(model).etag(model.version)

module.exports = GetTeamHandler
