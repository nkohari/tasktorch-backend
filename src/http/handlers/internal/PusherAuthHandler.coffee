_         = require 'lodash'
Handler   = require '../../framework/Handler'
UserModel = require '../../models/UserModel'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'

class PusherAuthHandler extends Handler

  @route 'post /api/_auth/presence'

  constructor: (@database, @pusher) ->

  handle: (request, reply) ->

    {user}         = request.auth.credentials
    socket         = request.payload.socket_id
    channel        = request.payload.channel_name
    organizationId = channel.replace('presence-', '')

    query = new GetOrganizationQuery(organizationId)
    @database.execute query, (err, organization) =>
      return reply err if err?
      return reply @error.notFound()  unless organization?
      return reply @error.forbidden() unless _.contains(organization.members, user.id)
      presenceInfo =
        user_id: user.id
        user_info: new UserModel(user, request)
      reply @pusher.getAuthToken(socket, channel, presenceInfo)

module.exports = PusherAuthHandler
