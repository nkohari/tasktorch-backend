Handler        = require 'apps/api/framework/Handler'
GetInviteQuery = require 'data/queries/invites/GetInviteQuery'

class GetInviteHandler extends Handler

  @route 'get /invites/{inviteid}'

  @before [
    'resolve query options'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {options}  = request.pre
    {inviteid} = request.params

    query = new GetInviteQuery(inviteid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.invite?
      reply @response(result)

module.exports = GetInviteHandler
