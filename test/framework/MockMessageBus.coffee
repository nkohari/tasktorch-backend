{EventEmitter} = require 'events'
_              = require 'lodash'
Activity       = require 'apps/watcher/Activity'
Message        = require 'apps/watcher/Message'

class MockMessageBus extends EventEmitter

  constructor: (@log, @watcher, @gatekeeper) ->

  start: (callback = (->)) ->
    @watcher.on('create', @onCreate)
    @watcher.on('update', @onUpdate)
    @watcher.on('delete', @onDelete)
    callback()

  onCreate: (event) =>
    @publish(Activity.Created, event.document)

  onUpdate: (event) =>
    @publish(Activity.Changed, event.document)

  onDelete: (event) =>
    @publish(Activity.Deleted, event.document)

  publish: (activity, document) =>
    @emit('message', new Message(activity, document))

module.exports = MockMessageBus
