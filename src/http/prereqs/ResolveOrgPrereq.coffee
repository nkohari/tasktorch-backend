Prereq      = require 'http/framework/Prereq'
GetOrgQuery = require 'data/queries/GetOrgQuery'

class ResolveOrgPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetOrgQuery(request.params.orgId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.org?
      reply(result.org)

module.exports = ResolveOrgPrereq
