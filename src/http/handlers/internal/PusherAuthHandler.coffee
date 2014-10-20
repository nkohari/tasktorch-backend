_              = require 'lodash'
{GetQuery}     = require 'data/queries'
{Organization} = require 'data/entities'
Handler        = require '../../framework/Handler'
UserModel      = require '../../models/UserModel'

class PusherAuthHandler extends Handler

  @route 'post /api/_auth/presence'

  constructor: (@database, @pusher) ->

  handle: (request, reply) ->

    {user}         = request.auth.credentials
    socketId       = request.payload.socket_id
    channel        = request.payload.channel_name
    organizationId = channel.replace('presence-', '')

    query = new GetQuery(Organization, organizationId)
    @database.execute query, (err, organization) =>
      return reply err if err?
      return reply @error.notFound()  unless organization?
      return reply @error.forbidden() unless organization.hasMember(user)
      presenceInfo =
        user_id: user.id
        user_info: new UserModel(user, request)
      reply @pusher.getAuthToken(socketId, channel, presenceInfo)

module.exports = PusherAuthHandler
