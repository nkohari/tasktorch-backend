Handler                = require 'http/framework/Handler'
SessionModel           = require 'http/models/SessionModel'
CreateSessionCommand   = require 'data/commands/CreateSessionCommand'
SessionCreatedEvent    = require 'data/events/SessionCreatedEvent'
GetUserByUsernameQuery = require 'data/queries/GetUserByUsernameQuery'
GetUserByEmailQuery    = require 'data/queries/GetUserByEmailQuery'

class CreateSessionHandler extends Handler

  @route 'post /api/sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @eventBus, @passwordHasher) ->

  handle: (request, reply) ->
    {login, password} = request.payload
    @resolveUser login, (err, user) =>
      return reply err if err?
      return reply @error.forbidden() unless user? and @passwordHasher.verify(user.password, password)
      session = {user: user.id, isActive: true}
      command = new CreateSessionCommand(session)
      @database.create session, (err) =>
        return reply err if err?
        event = new SessionCreatedEvent(session)
        @eventBus.publish event, metadata, (err) =>
          return reply err if err?
          request.auth.session.set {userId: user.id, sessionId: session.id}
          model = new SessionModel(session, request)
          reply(model).created(model.uri)

  resolveUser: (login, callback) ->
    query = new GetUserByUsernameQuery(login)
    @database.execute query, (err, user) =>
      return callback(err) if err?
      return callback(null, user) if user?
      query = new GetUserByEmailQuery(login)
      @database.execute query, (err, user) =>
        return callback(err) if err?
        callback(null, user)

module.exports = CreateSessionHandler
