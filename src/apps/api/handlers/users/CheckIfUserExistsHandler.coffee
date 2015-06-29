_                      = require 'lodash'
Handler                = require 'apps/api/framework/Handler'
GetUserByEmailQuery    = require 'data/queries/users/GetUserByEmailQuery'
GetUserByUsernameQuery = require 'data/queries/users/GetUserByUsernameQuery'

class CheckIfUserExistsHandler extends Handler

  @route 'get /users/exists'
  @auth  {mode: 'try'}

  @ensure
    query:
      email:    @mustBe.string()
      username: @mustBe.string()

  constructor: (@database) ->

  handle: (request, reply) ->

    {email, username} = request.query

    unless email?.length > 0 or username?.length > 0
      return reply @error.badRequest()

    @checkByEmail email, (err, exists) =>
      return reply err if err?
      return reply {exists: true} if exists
      @checkByUsername username, (err, exists) =>
        return reply err if err?
        return reply {exists}

  checkByEmail: (email, callback) ->
    return callback(null, false) unless email?
    query = new GetUserByEmailQuery(email)
    @database.execute query, (err, result) =>
      return callback err if err?
      callback(null, result.user?)

  checkByUsername: (username, callback) ->
    return callback(null, false) unless username?
    query = new GetUserByUsernameQuery(username)
    @database.execute query, (err, result) =>
      return callback err if err?
      callback(null, result.user?)

module.exports = CheckIfUserExistsHandler
