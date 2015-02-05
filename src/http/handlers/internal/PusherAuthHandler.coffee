_            = require 'lodash'
Handler      = require 'http/framework/Handler'
GetOrgQuery  = require 'data/queries/orgs/GetOrgQuery'
GetUserQuery = require 'data/queries/users/GetUserQuery'
UserModel    = require 'domain/models/UserModel'

class PusherAuthHandler extends Handler

  @route 'post /api/_wsauth'

  @validate
    payload:
      socket_id:    @mustBe.string().required()
      channel_name: @mustBe.string().required()

  constructor: (@database, @pusher) ->

  handle: (request, reply) ->

    {user}  = request.auth.credentials
    socket  = request.payload.socket_id
    channel = request.payload.channel_name

    if channel.indexOf('presence-') == 0
      getAuthToken = @getAuthTokenForPresenceChannel
    else
      getAuthToken = @getAuthTokenForUserChannel

    getAuthToken(user, socket, channel, reply)

  getAuthTokenForPresenceChannel: (user, socket, channel, reply) =>
    orgid = channel.replace('presence-org-', '')
    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such org #{orgid}") unless result.org?
      return reply @error.forbidden() unless result.org.hasMember(user.id)
      presenceInfo =
        user_id:   user.id
        user_info: new UserModel(user)
      reply @pusher.getAuthToken(socket, channel, presenceInfo)

  getAuthTokenForUserChannel: (user, socket, channel, reply) =>
    userid = channel.replace('private-user-', '')
    query  = new GetUserQuery(userid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such user #{userid}") unless result.user?
      return reply @error.forbidden()  unless result.user.id == user.id
      reply @pusher.getAuthToken(socket, channel)

module.exports = PusherAuthHandler
