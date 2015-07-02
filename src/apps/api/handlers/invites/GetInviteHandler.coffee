Handler        = require 'apps/api/framework/Handler'
GetInviteQuery = require 'data/queries/invites/GetInviteQuery'

class GetInviteHandler extends Handler

  @route 'get /invites/{inviteid}'
  @auth {mode: 'try'}

  constructor: (@database) ->

  handle: (request, reply) ->

    {inviteid} = request.params

    query = new GetInviteQuery(inviteid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.invite?
      reply @response(result)

module.exports = GetInviteHandler
