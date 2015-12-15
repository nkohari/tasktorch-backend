Handler                            = require 'apps/api/framework/Handler'
GetAllActiveMembershipsByUserQuery = require 'data/queries/memberships/GetAllActiveMembershipsByUserQuery'

class ListMyMembershipsHandler extends Handler

  @route 'get /{orgid}/me/memberships'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {options} = request.pre
    {user}    = request.auth.credentials

    query = new GetAllActiveMembershipsByUserQuery(user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMyMembershipsHandler
