Handler                  = require 'http/framework/Handler'
SuggestMembersByOrgQuery = require 'data/queries/users/SuggestMembersByOrgQuery'
GetAllMembersByOrgQuery  = require 'data/queries/users/GetAllMembersByOrgQuery'

class ListMembersByOrgHandler extends Handler

  @route 'get /api/{orgid}/members'

  @pre [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {org, options} = request.pre
    {suggest}      = request.query

    if suggest?.length > 0
      query = new SuggestMembersByOrgQuery(org.id, suggest, options)
    else
      query = new GetAllMembersByOrgQuery(org.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMembersByOrgHandler
