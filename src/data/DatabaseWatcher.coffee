{EventEmitter} = require 'events'
async          = require 'async'
Subscription   = require 'data/framework/Subscription'

DocTypes = [
  require 'data/documents/Card'
]

class DatabaseWatcher extends EventEmitter

  constructor: (@log, @connectionPool) ->

  start: (callback) ->

    createSubscription = (doctype, next) =>
      subscription = new Subscription(@connectionPool, doctype)
      subscription.start (err) =>
        return next(err) if err?
        @log.debug "[dbwatcher] Subscribed to changes on table #{doctype.getSchema().table}"
        subscription.on 'create', @onCreate
        subscription.on 'update', @onUpdate
        subscription.on 'delete', @onDelete
        next()

    async.each DocTypes, createSubscription, (err, subscriptions) =>
      return callback(err) if err?
      @subscriptions = subscriptions
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
