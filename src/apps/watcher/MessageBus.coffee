_        = require 'lodash'
Activity = require './Activity'
Message  = require './Message'

class MessageBus

  constructor: (@log, @watcher, @gatekeeper, @pusher) ->

  start: (callback = (->)) ->
    @log.info 'Message bus started, listening for changes from watcher'
    @watcher.on('create', @onCreate)
    @watcher.on('update', @onUpdate)
    @watcher.on('delete', @onDelete)
    callback()

  onCreate: (event) =>
    {document} = event
    @publish(document, new Message(Activity.Created, document))

  onUpdate: (event) =>
    {document, previous} = event
    @publish(document, new Message(Activity.Changed, document, previous))

  onDelete: (event) =>
    {document} = event
    @publish(document, new Message(Activity.Deleted, document))

  publish: (document, message) ->
    @gatekeeper.getAccessList document, (err, userids) =>
      if err?
        @log.error "Error resolving access list for #{document.constructor.name}: #{err}"
        return
      channels = _.map userids, (userid) -> "private-user-#{userid}"
      @log.debug "Sending #{message.activity} to channels: [#{channels.join(',')}]"
      @pusher.trigger(channels, message.activity, message)

module.exports = MessageBus
