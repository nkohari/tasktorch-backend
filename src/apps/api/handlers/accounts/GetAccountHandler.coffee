Handler                    = require 'apps/api/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'

class GetAccountHandler extends Handler

  @route 'get /{orgid}/account'

  @before [
    'resolve org'
    'ensure requester is leader of org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials

    reply(org.account)

module.exports = GetAccountHandler
