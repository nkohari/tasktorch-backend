_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetSpecialStackByOwner = require 'data/queries/GetSpecialStackByOwner'
GetAllCardsInStackQuery = require 'data/queries/GetAllCardsInStackQuery'

class GetMyFocusHandler extends Handler

  @route 'get /api/{organizationId}/me/focus'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {organization} = request.scope

    query = new GetSpecialStackByOwner(user.id, 'queue')
    @database.execute query, (err, stack) =>
      return reply err if err?
      options = _.extend {limit: 1}, @getQueryOptions(request)
      query = new GetAllCardsInStackQuery(stack.id, options)
      @database.execute query, (err, cards) =>
        return reply err if err?
        return reply {} if cards.length == 0
        model = @modelFactory.create(cards[0], request)
        reply(model).etag(model.version)

module.exports = GetMyFocusHandler
