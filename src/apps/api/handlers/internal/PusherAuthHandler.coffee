_            = require 'lodash'
Handler      = require 'apps/api/framework/Handler'
GetOrgQuery  = require 'data/queries/orgs/GetOrgQuery'
GetUserQuery = require 'data/queries/users/GetUserQuery'
UserModel    = require 'domain/models/UserModel'

class PusherAuthHandler extends Handler

  @route 'post /_wsauth'

  @ensure
    payload:
      socket_id:    @mustBe.string().required()
      channel_name: @mustBe.string().required()

  constructor: (@database, @gatekeeper, @pusher) ->

  handle: (request, reply) ->

    {user}  = request.auth.credentials
    socket  = request.payload.socket_id
    channel = request.payload.channel_name

    if channel.indexOf('presence-') == 0
      @getAuthTokenForPresenceChannel(user, socket, channel, reply)
    else
      @getAuthTokenForUserChannel(user, socket, channel, reply)

  getAuthTokenForPresenceChannel: (user, socket, channel, reply) ->
    orgid = channel.replace('presence-org-', '')
    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such org #{orgid}") unless result.org?
      {org} = result
      @gatekeeper.canUserAccess org, user, (err, canAccess) =>
        return reply err if err?
        return reply @error.forbidden() unless canAccess
        presenceInfo =
          user_id:   user.id
          user_info: new UserModel(user)
        reply @pusher.getAuthToken(socket, channel, presenceInfo)

  getAuthTokenForUserChannel: (user, socket, channel, reply) ->
    userid = channel.replace('private-user-', '')
    query  = new GetUserQuery(userid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such user #{userid}") unless result.user?
      return reply @error.forbidden() unless result.user.id == user.id
      reply @pusher.getAuthToken(socket, channel)

module.exports = PusherAuthHandler
