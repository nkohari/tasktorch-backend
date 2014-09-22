class Authenticator

  constructor: (@config, @sessionService) ->

  init: (server) ->
    server.pack.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      server.auth.strategy 'session', 'cookie', 'required',
        cookie:       'tt-sid'
        password:     @config.security.secret
        redirectTo:   false
        clearInvalid: true
        validateFunc: @validate.bind(this)

  validate: (state, callback) ->
    return callback(null, false) unless state?
    {userId, sessionId} = state
    @sessionService.get sessionId, {expand: 'user'}, (err, session) =>
      return callback(err) if err?
      return callback(null, false) unless session?
      return callback(null, false) unless session.isActive and session.user?.id == userId
      credentials = {session, user: session.user}
      callback(null, true, credentials)

module.exports = Authenticator
