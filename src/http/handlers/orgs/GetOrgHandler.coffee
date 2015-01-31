_           = require 'lodash'
Handler     = require 'http/framework/Handler'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class GetOrgHandler extends Handler

  @route 'get /api/{orgid}'

  @pre [
    'resolve query options'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {options} = request.pre
    {orgid}   = request.params
    {user}    = request.auth.credentials

    query = new GetOrgQuery(orgid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound()  unless result.org?
      return reply @error.forbidden() unless _.contains(result.org.members, user.id)
      reply @response(result)

module.exports = GetOrgHandler