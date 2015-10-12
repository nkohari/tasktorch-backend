Handler                        = require 'apps/api/framework/Handler'
GetAllTeamsByOrgAndMemberQuery = require 'data/queries/teams/GetAllTeamsByOrgAndMemberQuery'

class ListTeamsByOrgAndMemberHandler extends Handler

  @route 'get /{orgid}/members/{userid}/teams'

  @before [
    'resolve org'
    'resolve user'
    'resolve query options'
    'ensure user is member of org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, user, options} = request.pre

    query = new GetAllTeamsByOrgAndMemberQuery(org.id, user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListTeamsByOrgAndMemberHandler
