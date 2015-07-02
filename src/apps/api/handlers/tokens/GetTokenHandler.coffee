Handler       = require 'apps/api/framework/Handler'
GetTokenQuery = require 'data/queries/tokens/GetTokenQuery'

class GetTokenHandler extends Handler

  @route 'get /tokens/{tokenid}'
  @auth {mode: 'try'}

  constructor: (@database) ->

  handle: (request, reply) ->

    {tokenid} = request.params
    query = new GetTokenQuery(tokenid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.token?
      reply @response(result)

module.exports = GetTokenHandler
