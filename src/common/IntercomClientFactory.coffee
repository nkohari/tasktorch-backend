Intercom = require 'intercom.io'

class IntercomClientFactory

  constructor: (@config) ->

  createClient: ->
    new Intercom {
      apiKey: @config.intercom.apiKey
      appId:  @config.intercom.appId
    }

module.exports = IntercomClientFactory