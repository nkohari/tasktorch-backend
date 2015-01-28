Handler      = require 'http/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class GetMeHandler extends Handler

  @route 'get /api/me'

  constructor: (@log, @database) ->

  handle: (request, reply) ->
    @log.debug 'here'

    {options} = request.pre
    {user}    = request.auth.credentials
    
    query = new GetUserQuery(user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = GetMeHandler
