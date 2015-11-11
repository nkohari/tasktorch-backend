Handler                     = require 'apps/api/framework/Handler'
GetAllMembershipsByOrgQuery = require 'data/queries/memberships/GetAllMembershipsByOrgQuery'

class ListMembershipsByOrgHandler extends Handler

  @route 'get /{orgid}/memberships'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {org, options} = request.pre
    {suggest}      = request.query

    query = new GetAllMembershipsByOrgQuery(org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMembershipsByOrgHandler
