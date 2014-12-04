_ = require 'lodash'
Handler = require 'http/framework/Handler'
StackType = require 'data/enums/StackType'
GetSpecialStackByOrganizationAndUserQuery = require 'data/queries/GetSpecialStackByOrganizationAndUserQuery'

class GetMyQueueHandler extends Handler

  @route 'get /api/{organizationId}/me/queue'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {user}         = request.auth.credentials
    {organization} = request.scope
    query = new GetSpecialStackByOrganizationAndUserQuery(organization.id, user.id, StackType.Queue, @getQueryOptions(request))
    @database.execute query, (err, stack) =>
      return reply err if err?
      model = @modelFactory.create(stack, request)
      reply(model).etag(model.version)

module.exports = GetMyQueueHandler
