_           = require 'lodash'
Handler     = require 'http/framework/Handler'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'
UserModel   = require 'domain/models/UserModel'

class PusherAuthHandler extends Handler

  @route 'post /api/_auth/presence'

  constructor: (@database, @pusher) ->

  handle: (request, reply) ->

    {user}  = request.auth.credentials
    socket  = request.payload.socket_id
    channel = request.payload.channel_name
    orgid   = channel.replace('presence-', '')

    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound()  unless result.org?
      return reply @error.forbidden() unless _.contains(result.org.members, user.id)
      presenceInfo =
        user_id:   user.id
        user_info: new UserModel(user)
      reply @pusher.getAuthToken(socket, channel, presenceInfo)

module.exports = PusherAuthHandler
