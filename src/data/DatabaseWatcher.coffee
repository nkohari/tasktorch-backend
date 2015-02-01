{EventEmitter} = require 'events'
async          = require 'async'
Schema         = require 'data/framework/Schema'
Subscription   = require 'data/framework/Subscription'

class DatabaseWatcher extends EventEmitter

  constructor: (@log, @forge, @connectionPool) ->

  start: (callback = (->)) ->
    @log.debug "[dbwatcher] Subscribing to changefeeds"

    createSubscription = (schema, next) =>
      doctype = schema.getDoctype()
      subscription = new Subscription(@connectionPool, doctype)
      subscription.start (err) =>
        return next(err) if err?
        @log.debug "[dbwatcher] Subscribed to changes for doctype #{doctype.name} (table #{doctype.getSchema().table})"
        subscription.on 'create', @onCreate
        subscription.on 'update', @onUpdate
        subscription.on 'delete', @onDelete
        next(null, subscription)

    async.map Schema.getAll(), createSubscription, (err, subscriptions) =>
      return callback(err) if err?
      @subscriptions = subscriptions
      @log.debug "[dbwatcher] Subscribed to changes on #{@subscriptions.length} tables"
      callback()

  onCreate: (event) =>
    @log.debug("[dbwatcher] Create: #{event.type} #{event.document.id}")
    @emit('create', event)
  
  onUpdate: (event) =>
    @log.debug("[dbwatcher] Update: #{event.type} #{event.document.id}")
    @emit('update', event)

  onDelete: (event) =>
    @log.debug("[dbwatcher] Delete: #{event.type} #{event.document.id}")
    @emit('delete', event)

module.exports = DatabaseWatcher
