Handler = require 'http/framework/Handler'

class GetMeHandler extends Handler

  @route 'get /api/me'

  constructor: (@modelFactory) ->

  handle: (request, reply) ->
    model = @modelFactory.create(request.auth.credentials.user, request)
    reply(model).etag(model.version)

module.exports = GetMeHandler
