Session      = require 'data/entities/Session'
SessionModel = require '../models/SessionModel'
Controller   = require '../framework/Controller'

class SessionController extends Controller

  constructor: (@userService, @sessionService, @passwordHasher) ->

  create: (request, reply) ->
    {username, password} = request.payload
    @userService.getBy {username}, (err, user) =>
      return reply @error(err)     if err?
      return reply @unauthorized() unless user? and @passwordHasher.verify(user.password, password)
      session = new Session {user, isActive: true}
      @sessionService.create session, (err) =>
        return reply @error(err) if err?
        request.auth.session.set {userId: user.id, sessionId: session.id}
        return reply new SessionModel(session)

  end: (request, reply) ->
    {session} = request.credentials
    session.isActive = false
    @sessionService.save session, (err) =>
      return reply @error(err) if err?
      request.auth.session.clear()
      reply()

module.exports = SessionController
