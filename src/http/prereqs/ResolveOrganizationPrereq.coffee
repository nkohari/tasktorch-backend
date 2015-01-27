Prereq               = require 'http/framework/Prereq'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'

class ResolveOrganizationPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetOrganizationQuery(request.params.organizationId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.organization?
      reply(result.organization)

module.exports = ResolveOrganizationPrereq
