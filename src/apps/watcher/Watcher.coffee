EventEmitter = require 'events'
async        = require 'async'
DocTypes     = require 'apps/watcher/DocTypes'
Schema       = require 'data/framework/Schema'
Subscription = require 'data/framework/Subscription'

class Watcher extends EventEmitter

  constructor: (@log, @forge, @connectionPool) ->

  start: (callback = (->)) ->
    @log.debug "Subscribing to changefeeds"

    createSubscription = (doctype, next) =>
      subscription = new Subscription(@connectionPool, doctype)
      subscription.start (err) =>
        return next(err) if err?
        @log.debug "Subscribed to changes for doctype #{doctype.name} (table #{doctype.getSchema().table})"
        subscription.on 'create', @onCreate
        subscription.on 'update', @onUpdate
        subscription.on 'delete', @onDelete
        next(null, subscription)

    async.map DocTypes, createSubscription, (err, subscriptions) =>
      return callback(err) if err?
      @subscriptions = subscriptions
      @log.debug "Subscribed to changes on #{@subscriptions.length} tables"
      callback()

  onCreate: (event) =>
    @log.debug("Create: #{event.type} #{event.document.id}")
    @emit('create', event)
  
  onUpdate: (event) =>
    @log.debug("Update: #{event.type} #{event.document.id}")
    @emit('update', event)

  onDelete: (event) =>
    @log.debug("Delete: #{event.type} #{event.document.id}")
    @emit('delete', event)

module.exports = Watcher
