{Session, User} = require 'data/entities'
{GetByQuery}    = require 'data/queries'
SessionModel    = require '../../models/SessionModel'
Handler         = require '../../framework/Handler'

class CreateSessionHandler extends Handler

  @route 'post /api/sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @passwordHasher) ->

  handle: (request, reply) ->
    {login, password} = request.payload
    @resolveUser login, (err, user) =>
      return reply err if err?
      return reply @error.forbidden() unless user? and @passwordHasher.verify(user.password, password)
      session = new Session {user, isActive: true}
      @database.create session, (err) =>
        return reply err if err?
        request.auth.session.set {userId: user.id, sessionId: session.id}
        reply new SessionModel(session)

  resolveUser: (login, callback) ->
    query = new GetByQuery(User, {username: login})
    @database.execute query, (err, user) =>
      return callback(err) if err?
      return callback(null, user) if user?
      query = new GetByQuery(User, {emails: login})
      @database.execute query, (err, user) =>
        return callback(err) if err?
        callback(null, user)

module.exports = CreateSessionHandler
