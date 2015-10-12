Handler                   = require 'apps/api/framework/Handler'
ChangeProfileTitleCommand = require 'domain/commands/profiles/ChangeProfileTitleCommand'

class ChangeMyTitleHandler extends Handler

  @route 'post /{orgid}/me/profile/title'

  @ensure
    payload:
      title: @mustBe.string().allow(null, '').required()

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {title} = request.payload
    {org}   = request.pre
    {user}  = request.auth.credentials

    command = new ChangeProfileTitleCommand(user, org, title)
    @processor.execute command, (err, user) =>
      return reply err if err?
      reply @response(user)

module.exports = ChangeMyTitleHandler
