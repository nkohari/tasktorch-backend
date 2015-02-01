_            = require 'lodash'
Handler      = require 'http/framework/Handler'
GetOrgQuery  = require 'data/queries/orgs/GetOrgQuery'
GetUserQuery = require 'data/queries/users/GetUserQuery'
UserModel    = require 'domain/models/UserModel'

class PusherAuthHandler extends Handler

  @route 'post /api/_wsauth'

  constructor: (@database, @pusher) ->

  handle: (request, reply) ->

    {user}  = request.auth.credentials
    socket  = request.payload.socket_id
    channel = request.payload.channel_name

    if channel.indexOf('presence-') == 0
      getAuthToken = @getAuthTokenForPresenceChannel
    else
      getAuthToken = @getAuthTokenForUserChannel

    getAuthToken user, socket, channel, (err, token) =>
      return reply(err) if err?
      reply(token)

  getAuthTokenForPresenceChannel: (user, socket, channel, callback) =>
    orgid = channel.replace('presence-org-', '')
    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>
      return callback err if err?
      return callback @error.notFound()  unless result.org?
      return callback @error.forbidden() unless result.org.hasMember(user.id)
      presenceInfo =
        user_id:   user.id
        user_info: new UserModel(user)
      callback @pusher.getAuthToken(socket, channel, presenceInfo)

  getAuthTokenForUserChannel: (user, socket, channel, callback) =>
    userid = channel.replace('private-user-', '')
    query  = new GetUserQuery(userid)
    @database.execute query, (err, result) =>
      return callback err if err?
      return callback @error.notFound()  unless result.user?
      return callback @error.forbidden() unless result.user.id == user.id
      callback @pusher.getAuthToken(socket, channel)

module.exports = PusherAuthHandler
