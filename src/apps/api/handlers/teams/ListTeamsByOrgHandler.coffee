Handler                = require 'apps/api/framework/Handler'
SuggestTeamsByOrgQuery = require 'data/queries/teams/SuggestTeamsByOrgQuery'
GetAllTeamsByOrgQuery  = require 'data/queries/teams/GetAllTeamsByOrgQuery'

class ListTeamsByOrgHandler extends Handler

  @route 'get /{orgid}/teams'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {suggest}      = request.query

    if suggest?.length > 0
      query = new SuggestTeamsByOrgQuery(org.id, suggest, options)
    else
      query = new GetAllTeamsByOrgQuery(org.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListTeamsByOrgHandler
