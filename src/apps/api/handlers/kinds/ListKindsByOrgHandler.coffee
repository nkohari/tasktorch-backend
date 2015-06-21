Handler               = require 'apps/api/framework/Handler'
GetAllKindsByOrgQuery = require 'data/queries/kinds/GetAllKindsByOrgQuery'

class ListKindsByOrgHandler extends Handler

  @route 'get /{orgid}/kinds'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {org, options} = request.pre
    query = new GetAllKindsByOrgQuery(org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListKindsByOrgHandler
