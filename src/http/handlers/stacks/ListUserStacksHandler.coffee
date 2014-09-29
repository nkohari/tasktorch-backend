_             = require 'lodash'
{Stack}       = require 'data/entities'
GetAllByQuery = require 'data/queries/GetAllByQuery'
StackModel    = require '../../models/StackModel'
Handler       = require '../../framework/Handler'

class ListUserStacksHandler extends Handler

  @route 'get /organizations/{organizationId}/users/{userId}/stacks'
  @demand ['requester is organization member', 'requester is user']

  constructor: (@database) ->

  handle: (request, reply) ->
    expand = request.query.expand?.split(',')
    query  = new GetAllByQuery(Stack, {owner: request.scope.user.id}, {expand})
    @database.execute query, (err, stacks) =>
      return reply err if err?
      reply _.map stacks, (stack) -> new StackModel(request.baseUrl, stack)

module.exports = ListUserStacksHandler
