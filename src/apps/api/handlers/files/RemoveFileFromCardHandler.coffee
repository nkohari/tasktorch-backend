Handler                   = require 'apps/api/framework/Handler'
RemoveFileFromCardCommand = require 'domain/commands/files/RemoveFileFromCardCommand'

class RemoveFileFromCardHandler extends Handler

  @route 'delete /{orgid}/cards/{cardid}/files/{fileid}'

  @before [
    'resolve org'
    'resolve file'
    'resolve card'
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

    command = new RemoveFileFromCardCommand(user, file, card)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = RemoveFileFromCardHandler
