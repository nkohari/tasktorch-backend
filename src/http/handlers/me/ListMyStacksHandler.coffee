Handler                       = require 'http/framework/Handler'
GetAllStacksByOrgAndUserQuery = require 'data/queries/stacks/GetAllStacksByOrgAndUserQuery'

class ListMyStacksHandler extends Handler

  @route 'get /api/{orgid}/me/stacks'

  @pre [
    'resolve org'
    'resolve query options'
    'ensure requester is member of org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {user}         = request.auth.credentials

    query = new GetAllStacksByOrgAndUserQuery(org.id, user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMyStacksHandler
