Handler      = require 'apps/api/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class CreateOnboardingDataHandler extends Handler

  @route 'post /{orgid}/me/onboarding'

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@onboarder) ->

  handle: (request, reply) ->
    {org}  = request.pre
    {user} = request.auth.credentials
    @onboarder.createSampleCard user, org.id, (err, callback) ->
      return reply err if err?
      reply()

module.exports = CreateOnboardingDataHandler
