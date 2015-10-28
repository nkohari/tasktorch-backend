EventEmitter = require 'events'
async        = require 'async'
DocTypes     = require 'data/framework/DocTypes'
Schema       = require 'data/framework/Schema'
Subscription = require 'data/framework/Subscription'
Activity     = require './framework/Activity'

class ChangeWatcher extends EventEmitter

  constructor: (@log, @forge, @database) ->
    @rules = @forge.getAll('rule')
    for rule in @rules
      @log.debug "Registered #{rule.constructor.name}"

  start: (callback = (->)) ->
    @log.debug "Subscribing to changefeeds"

    createSubscription = (doctype, next) =>
      @database.subscribe doctype, (err, subscription) =>
        if err?
          @log.error "Error subscribing to changes for doctype #{doctype.name}: #{err}"
          return next(err)
        @log.debug "Subscribed to changes for doctype #{doctype.name} (table #{doctype.getSchema().table})"
        subscription.on 'create', @handleEvent.bind(this, Activity.Created)
        subscription.on 'update', @handleEvent.bind(this, Activity.Changed)
        subscription.on 'delete', @handleEvent.bind(this, Activity.Deleted)
        next(null, subscription)

    async.map DocTypes, createSubscription, (err, subscriptions) =>
      return callback(err) if err?
      @subscriptions = subscriptions
      @log.debug "Subscribed to changes on #{@subscriptions.length} tables"
      callback()

  handleEvent: (activity, event, callback) ->
    @log.debug("[change] #{activity}: #{event.type} #{event.document.id}")
    delegate = (rule, next) =>
      if rule.offer(activity, event)
        rule.handle(activity, event, next)
      next()
    async.eachSeries @rules, delegate, (err) =>
      @log.error("Error handling event: #{err.stack ? err}") if err?
      @log.debug("Done handling event")

module.exports = ChangeWatcher
