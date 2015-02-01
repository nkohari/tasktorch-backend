_        = require 'lodash'
Activity = require 'messaging/Activity'
Message  = require 'messaging/Message'

class MessageBus

  constructor: (@log, @databaseWatcher, @gatekeeper, @pusher) ->

  start: (callback = (->)) ->
    @databaseWatcher.on('create', @onCreate)
    @databaseWatcher.on('update', @onUpdate)
    @databaseWatcher.on('delete', @onDelete)
    callback()

  onCreate: (event) =>
    @publish(Activity.Created, event.document)

  onUpdate: (event) =>
    @publish(Activity.Changed, event.document)

  onDelete: (event) =>
    @publish(Activity.Deleted, event.document)

  publish: (activity, document) =>
    message = new Message(activity, document)
    @gatekeeper.getAccessList document, (err, userids) =>
      if err?
        @log.error "Error resolving access list for #{document.constructor.name}: #{err}"
        return
      channels = _.map userids, (userid) -> "private-user-#{userid}"
      @log.debug "Sending #{message.activity} to channels: [#{channels.join(',')}]"
      @pusher.trigger(channels, message.activity, message)

module.exports = MessageBus
