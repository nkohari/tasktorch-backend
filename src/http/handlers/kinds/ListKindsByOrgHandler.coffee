Handler               = require 'http/framework/Handler'
GetAllKindsByOrgQuery = require 'data/queries/kinds/GetAllKindsByOrgQuery'

class ListKindsByOrgHandler extends Handler

  @route 'get /api/{orgid}/kinds'

  @pre [
    'resolve org'
    'resolve query options'
    'ensure requester is member of org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {org, options} = request.pre
    query = new GetAllKindsByOrgQuery(org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListKindsByOrgHandler
