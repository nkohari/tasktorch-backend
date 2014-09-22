Session      = require 'data/entities/Session'
SessionModel = require '../../models/SessionModel'
Handler      = require '../../framework/Handler'

class CreateSessionHandler extends Handler

  @route 'post /sessions'
  @auth  {mode: 'try'}

  constructor: (log, @userService, @sessionService, @passwordHasher) ->
    super(log)

  handle: (request, reply) ->
    {username, password} = request.payload
    @userService.getBy {username}, (err, user) =>
      return reply @error(err)     if err?
      return reply @unauthorized() unless user? and @passwordHasher.verify(user.password, password)
      session = new Session {user, isActive: true}
      @sessionService.create session, (err) =>
        return reply @error(err) if err?
        request.auth.session.set {userId: user.id, sessionId: session.id}
        return reply new SessionModel(session)

module.exports = CreateSessionHandler
