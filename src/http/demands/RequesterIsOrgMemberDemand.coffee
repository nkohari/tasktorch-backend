_           = require 'lodash'
GetOrgQuery = require 'data/queries/GetOrgQuery'
Demand      = require '../framework/Demand'

class RequesterIsOrgMemberDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials
    {orgId} = request.params
    query = new GetOrgQuery(orgId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.org?
      request.scope.org = result.org
      if _.contains(result.org.members, user.id)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsOrgMemberDemand
