{Team}     = require 'data/entities'
{GetQuery} = require 'data/queries'
TeamModel  = require '../../models/TeamModel'
Handler    = require '../../framework/Handler'

class GetTeamHandler extends Handler

  @route 'get /api/{organizationId}/teams/{teamId}'
  @demand ['requester is organization member', 'team belongs to organization']

  constructor: (@database) ->

  handle: (request, reply) ->
    {teamId} = request.params
    expand   = request.query.expand?.split(',')
    query    = new GetQuery(Team, teamId, {expand})
    @database.execute query, (err, team) =>
      return reply err if err?
      reply new TeamModel(team, request)

module.exports = GetTeamHandler
