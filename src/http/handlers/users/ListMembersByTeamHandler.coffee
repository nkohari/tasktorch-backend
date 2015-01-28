Handler                  = require 'http/framework/Handler'
GetAllMembersByTeamQuery = require 'data/queries/users/GetAllMembersByTeamQuery'

class ListMembersByTeamHandler extends Handler

  @route 'get /api/{orgid}/teams/{teamid}/members'

  @pre [
    'resolve org'
    'resolve team'
    'resolve query options'
    'ensure team belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {team, options} = request.pre
    query = new GetAllMembersByTeamQuery(team.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMembersByTeamHandler
