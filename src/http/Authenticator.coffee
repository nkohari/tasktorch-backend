GetSessionQuery = require 'data/queries/sessions/GetSessionQuery'

class Authenticator

  constructor: (@log, @config, @database) ->

  init: (server) ->
    {cookie} = @config.security
    server.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      server.auth.strategy 'session', 'cookie', 'required',
        cookie:       cookie.name
        domain:       cookie.domain
        ttl:          cookie.ttl
        password:     cookie.secret
        isSecure:     cookie.secure
        clearInvalid: true
        validateFunc: @validate.bind(this)

  validate: (state, callback) ->
    return callback(null, false) unless state?
    {sessionid, userid} = state
    return callback(null, false) unless sessionid? and userid?
    query = new GetSessionQuery(sessionid, {expand: 'user'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      session = result.session
      return callback(null, false) unless session?
      return callback(null, false) unless session.isActive and session.user == userid
      user = result.related.users[session.user]
      credentials = {session: session, user}
      @log.debug "Authenticated session #{session.id} for user #{user.username}"
      callback(null, true, credentials)

module.exports = Authenticator
