GetSessionQuery = require 'data/queries/sessions/GetSessionQuery'

class Keymaster

  constructor: (@log, @database) ->

  validateSession: (sessionid, userid, callback) ->
    return callback(null, false) unless sessionid? and userid?
    query = new GetSessionQuery(sessionid, {expand: 'user'})
    @database.execute query, (err, result) =>
      return callback(err) if err?

      {session} = result
      user      = result.related.users[session.user] if session?

      return callback(null, false) unless session?
      return callback(null, false) unless session.isActive and session.user == userid

      @log.debug "Authenticated session #{session.id} for user #{user.username}"
      callback(null, true, {session, user})

module.exports = Keymaster
