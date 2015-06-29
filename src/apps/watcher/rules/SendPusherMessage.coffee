_             = require 'lodash'
Rule          = require 'apps/watcher/framework/Rule'
PusherMessage = require 'apps/watcher/framework/PusherMessage'

class SendPusherMessage extends Rule

  constructor: (@log, @gatekeeper, @pusher) ->

  offer: (activity, event) ->
    true # handle everything

  handle: (activity, event, callback) ->
    {document, previous} = event
    message = new PusherMessage(activity, document, previous)
    @gatekeeper.getAccessList document, (err, userids) =>
      if err?
        @log.error "Error resolving access list for #{document.constructor.name}: #{err}"
        return callback(err)
      channels = _.map userids, (userid) -> "private-user-#{userid}"
      @log.debug "[pusher] Sending #{message.activity} to channels: [#{channels.join(',')}]"
      @pusher.trigger(channels, message.activity, message)
      callback()

module.exports = SendPusherMessage
