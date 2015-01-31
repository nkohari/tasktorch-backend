Handler                = require 'http/framework/Handler'
CreateSessionCommand   = require 'domain/commands/sessions/CreateSessionCommand'
Session                = require 'data/documents/Session'
GetUserByUsernameQuery = require 'data/queries/users/GetUserByUsernameQuery'
GetUserByEmailQuery    = require 'data/queries/users/GetUserByEmailQuery'

class CreateSessionHandler extends Handler

  @route 'post /api/sessions'
  @auth  {mode: 'try'}

  constructor: (@database, @processor, @passwordHasher) ->

  handle: (request, reply) ->

    {login, password} = request.payload

    unless login?.length > 0
      return reply @error.badRequest("Missing required argument 'login'")

    unless password?.length > 0
      return reply @error.badRequest("Missing required argument 'password'")

    @resolveUser login, (err, user) =>
      return reply err if err?
      return reply @error.forbidden() unless user? and @passwordHasher.verify(user.password, password)
      session = new Session {
        user: user.id
        isActive: true
      }
      command = new CreateSessionCommand(user, session)
      @processor.execute command, (err, session) =>
        return reply err if err?
        request.auth.session.set {userid: user.id, sessionid: session.id}
        reply @response(session)

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
