Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'
CreateSessionCommand   = require 'domain/commands/CreateSessionCommand'
GetUserByUsernameQuery = require 'data/queries/GetUserByUsernameQuery'
GetUserByEmailQuery    = require 'data/queries/GetUserByEmailQuery'

class CreateSessionHandler extends Handler

  @route 'post /api/sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @processor, @passwordHasher) ->

  handle: (request, reply) ->
    {login, password} = request.payload
    @resolveUser login, (err, user) =>
      return reply err if err?
      return reply @error.forbidden() unless user? and @passwordHasher.verify(user.password, password)
      data = {user: user.id, isActive: true}
      command = new CreateSessionCommand(user, data)
      @processor.execute command, (err, result) =>
        return reply @error.notFound() if err is Error.DocumentNotFound
        return reply @error.conflict() if err is Error.VersionMismatch
        return reply err if err?
        request.auth.session.set {userId: user.id, sessionId: result.session.id}
        reply new Response(result.session)

  resolveUser: (login, callback) ->
    query = new GetUserByUsernameQuery(login)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback(null, result.user) if result.user?
      query = new GetUserByEmailQuery(login)
      @database.execute query, (err, result) =>
        return callback(err) if err?
        callback(null, result.user)

module.exports = CreateSessionHandler
