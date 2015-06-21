Handler      = require 'apps/api/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class GetMeHandler extends Handler

  @route 'get /me'

  constructor: (@log, @database) ->

  handle: (request, reply) ->

    {options} = request.pre
    {user}    = request.auth.credentials
    
    query = new GetUserQuery(user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = GetMeHandler
