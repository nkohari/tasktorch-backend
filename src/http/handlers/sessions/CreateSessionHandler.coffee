{Session, User} = require 'data/entities'
GetByQuery      = require 'data/queries/GetByQuery'
SessionModel    = require '../../models/SessionModel'
Handler         = require '../../framework/Handler'

class CreateSessionHandler extends Handler

  @route 'post /sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @passwordHasher) ->

  handle: (request, reply) ->
    {username, password} = request.payload
    query = new GetByQuery(User, {username})
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.unauthorized() unless user? and @passwordHasher.verify(user.password, password)
      session = new Session {user, isActive: true}
      @database.create session, (err) =>
        return reply err if err?
        request.auth.session.set {userId: user.id, sessionId: session.id}
        reply new SessionModel(session)

module.exports = CreateSessionHandler
