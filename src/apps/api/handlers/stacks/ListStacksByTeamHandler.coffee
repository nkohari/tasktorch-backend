Handler                 = require 'apps/api/framework/Handler'
GetAllStacksByTeamQuery = require 'data/queries/stacks/GetAllStacksByTeamQuery'

class ListStacksByTeamHandler extends Handler

  @route 'get /{orgid}/teams/{teamid}/stacks'

  @before [
    'resolve org'
    'resolve team'
    'resolve query options'
    'ensure org has active subscription'
    'ensure team belongs to org'
    'ensure requester can access team'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {team, options} = request.pre
    query = new GetAllStacksByTeamQuery(team.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListStacksByTeamHandler
