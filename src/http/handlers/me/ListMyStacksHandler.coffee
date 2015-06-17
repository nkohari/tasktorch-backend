Handler                       = require 'http/framework/Handler'
GetAllStacksByOrgAndUserQuery = require 'data/queries/stacks/GetAllStacksByOrgAndUserQuery'

class ListMyStacksHandler extends Handler

  @route 'get /{orgid}/me/stacks'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
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
