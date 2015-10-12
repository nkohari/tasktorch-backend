Handler                 = require 'apps/api/framework/Handler'
ChangeProfileBioCommand = require 'domain/commands/profiles/ChangeProfileBioCommand'

class ChangeMyBioHandler extends Handler

  @route 'post /{orgid}/me/profile/bio'

  @ensure
    payload:
      bio: @mustBe.string().allow(null, '').required()

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {bio}  = request.payload
    {org}  = request.pre
    {user} = request.auth.credentials

    command = new ChangeProfileBioCommand(user, org, bio)
    @processor.execute command, (err, user) =>
      return reply err if err?
      reply @response(user)

module.exports = ChangeMyBioHandler
