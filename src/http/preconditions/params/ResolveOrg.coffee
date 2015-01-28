Precondition = require 'http/framework/Precondition'
GetOrgQuery  = require 'data/queries/orgs/GetOrgQuery'

class ResolveOrg extends Precondition

  assign: 'org'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetOrgQuery(request.params.orgid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.org?
      reply(result.org)

module.exports = ResolveOrg
