_           = require 'lodash'
GetOrgQuery = require 'data/queries/GetOrgQuery'
Demand      = require '../framework/Demand'

class UserIsMemberOfOrgDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {orgId, userId} = request.params
    query = new GetOrgQuery(orgId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.org?
      if _.contains(result.org.members, userId)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = UserIsMemberOfOrgDemand
