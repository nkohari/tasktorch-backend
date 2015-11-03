Handler                = require 'apps/api/framework/Handler'
SuggestUsersByOrgQuery = require 'data/queries/users/SuggestUsersByOrgQuery'
GetAllUsersByOrgQuery  = require 'data/queries/users/GetAllUsersByOrgQuery'

class ListUsersByOrgHandler extends Handler

  @route 'get /{orgid}/users'

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {org, options} = request.pre
    {suggest}      = request.query

    if suggest?.length > 0
      query = new SuggestUsersByOrgQuery(org.id, suggest, options)
    else
      query = new GetAllUsersByOrgQuery(org.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListUsersByOrgHandler
