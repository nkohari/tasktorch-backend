User       = require 'data/entities/User'
Controller = require '../framework/Controller'

class UserController extends Controller

  constructor: (@log, @userService) ->

  changePassword: (request, reply) ->
    {userId}   = request.params
    {password} = request.payload
    @userService.get userId, (err, user) =>
      return reply @error(err) if err?
      return reply @notFound() unless user?
      @userService.changePassword user, password, (err) =>
        return reply @error(err) if err?
        return reply()

module.exports = UserController
