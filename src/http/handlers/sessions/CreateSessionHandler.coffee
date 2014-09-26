User         = require 'data/entities/User'
GetByQuery   = require 'data/queries/GetByQuery'
SessionModel = require '../../models/SessionModel'
Handler      = require '../../framework/Handler'

class CreateSessionHandler extends Handler

  @route 'post /sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @sessionService, @passwordHasher) ->

  handle: (request, reply) ->
    {username, password} = request.payload
    query = new GetByQuery(User, {username})
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.unauthorized() unless user? and @passwordHasher.verify(user.password, password)
      data = {user, isActive: true}
      @sessionService.create data, (err, session) =>
        return reply err if err?
        request.auth.session.set {userId: user.id, sessionId: session.id}
        return reply new SessionModel(session)

module.exports = CreateSessionHandler
