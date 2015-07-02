Precondition   = require 'apps/api/framework/Precondition'
GetInviteQuery = require 'data/queries/invites/GetInviteQuery'

class ResolveOptionalInviteArgument extends Precondition

  assign: 'invite'

  constructor: (@database) ->

  execute: (request, reply) ->
    inviteid = request.payload.invite
    return reply(null) unless inviteid?
    query = new GetInviteQuery(inviteid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such invite #{inviteid}") unless result.invite?
      reply(result.invite)

module.exports = ResolveOptionalInviteArgument
