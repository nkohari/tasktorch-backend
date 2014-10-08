{Session} = require 'data/entities'
GetQuery  = require 'data/queries/GetQuery'

class Authenticator

  constructor: (@log, @config, @database) ->

  init: (server) ->
    {cookie} = @config.security
    server.pack.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      server.auth.strategy 'session', 'cookie', 'required',
        cookie:       cookie.name
        domain:       cookie.domain
        ttl:          cookie.ttl
        password:     cookie.secret
        isSecure:     cookie.secure
        redirectTo:   false
        clearInvalid: true
        validateFunc: @validate.bind(this)

  validate: (state, callback) ->
    return callback(null, false) unless state?
    {userId, sessionId} = state
    query = new GetQuery(Session, sessionId, {expand: 'user'})
    @database.execute query, (err, session) =>
      return callback(err) if err?
      return callback(null, false) unless session?
      return callback(null, false) unless session.isActive and session.user?.id == userId
      credentials = {session, user: session.user}
      @log.debug "Authenticated session #{session.id} for user #{session.user.username}"
      callback(null, true, credentials)

module.exports = Authenticator
