Handler                        = require 'http/framework/Handler'
GetAllTeamsByOrgAndMemberQuery = require 'data/queries/teams/GetAllTeamsByOrgAndMemberQuery'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{orgid}/me/teams'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {user}         = request.auth.credentials

    query = new GetAllTeamsByOrgAndMemberQuery(org.id, user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMyTeamsHandler
