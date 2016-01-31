Handler              = require 'apps/api/framework/Handler'
AddFileToCardCommand = require 'domain/commands/files/AddFileToCardCommand'

class AddFileToCardHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/files'

  @ensure
    payload:
      file: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve card'
    'resolve file argument'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure file belongs to org'
    'ensure requester can access card'
    'ensure requester can access file'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, file, card} = request.pre
    {user}            = request.auth.credentials

    command = new AddFileToCardCommand(user, file, card)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = AddFileToCardHandler
