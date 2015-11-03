_            = require 'lodash'
Handler      = require 'apps/api/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class GetOrgMemberHandler extends Handler

  @route 'get /users/{userid}'

  @before [
    'resolve query options'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {options} = request.pre
    {userid}  = request.params

    query = new GetUserQuery(userid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.user?
      reply @response(result)

module.exports = GetOrgMemberHandler
