_                           = require 'lodash'
Handler                     = require 'apps/api/framework/Handler'
GetProfileByUserAndOrgQuery = require 'data/queries/profiles/GetProfileByUserAndOrgQuery'

class GetUserProfileHandler extends Handler

  @route 'get /{orgid}/users/{userid}/profile'

  @before [
    'resolve org'
    'resolve user'
    'ensure org has active subscription'
    'ensure user is member of org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, user, options} = request.pre

    query = new GetProfileByUserAndOrgQuery(user.id, org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.profile?
      reply @response(result)

module.exports = GetUserProfileHandler
