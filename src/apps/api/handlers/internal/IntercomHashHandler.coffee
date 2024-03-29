crypto       = require 'crypto'
Handler      = require 'apps/api/framework/Handler'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class IntercomHashHandler extends Handler

  @route 'get /_intercom'

  constructor: (@config) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials

    hmac = crypto.createHmac('sha256', @config.intercom.secret)
    hmac.update(user.id)

    reply {token: hmac.digest('base64')}

module.exports = IntercomHashHandler
