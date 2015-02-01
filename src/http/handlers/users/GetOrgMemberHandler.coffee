_            = require 'lodash'
Handler      = require 'http/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class GetOrgMemberHandler extends Handler

  @route 'get /api/{orgid}/members/{userid}'

  @pre [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {userid}       = request.params

    query = new GetUserQuery(userid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.user?
      return reply @error.notFound() unless _.contains(org.members, result.user.id)
      reply @response(result)

module.exports = GetOrgMemberHandler
