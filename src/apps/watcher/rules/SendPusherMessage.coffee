_             = require 'lodash'
Rule          = require 'apps/watcher/framework/Rule'
PusherMessage = require 'apps/watcher/framework/PusherMessage'

MAX_MESSAGES_PER_TRIGGER = 10

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
      chunks   = _.chunk(channels, MAX_MESSAGES_PER_TRIGGER)

      for chunk in chunks
        @log.debug "[pusher] #{document.getSchema().name} #{document.id} #{message.activity} sent to #{chunk.length} channels: [#{chunk.join(', ')}]"
        @pusher.trigger(chunk, message.activity, message)

      callback()

module.exports = SendPusherMessage
