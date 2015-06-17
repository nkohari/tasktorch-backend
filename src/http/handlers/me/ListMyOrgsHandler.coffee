Handler                 = require 'http/framework/Handler'
GetAllOrgsByMemberQuery = require 'data/queries/orgs/GetAllOrgsByMemberQuery'

class ListMyOrgsHandler extends Handler

  @route 'get /me/orgs'

  @before [
    'resolve query options'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {options} = request.pre
    {user}    = request.auth.credentials

    query = new GetAllOrgsByMemberQuery(user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMyOrgsHandler
