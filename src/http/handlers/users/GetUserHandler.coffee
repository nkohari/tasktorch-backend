{User}     = require 'data/entities'
{GetQuery} = require 'data/queries'
UserModel  = require '../../models/UserModel'
Handler    = require '../../framework/Handler'

class GetUserHandler extends Handler

  @route 'get /users/{userId}'
  @demand 'requester is user'

  constructor: (@database) ->

  handle: (request, reply) ->
    {userId} = request.params
    expand   = request.query.expand?.split(',')
    query    = new GetQuery(User, userId, {expand})
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      reply new UserModel(user)

module.exports = GetUserHandler
