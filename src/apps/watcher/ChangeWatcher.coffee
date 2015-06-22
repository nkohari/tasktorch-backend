EventEmitter = require 'events'
async        = require 'async'
Schema       = require 'data/framework/Schema'
Subscription = require 'data/framework/Subscription'
Activity     = require './framework/Activity'
DocTypes     = require './framework/DocTypes'

class ChangeWatcher extends EventEmitter

  constructor: (@log, @forge, @database) ->
    @rules = @forge.getAll('rule')
    for rule in @rules
      @log.debug "Registered #{rule.constructor.name}"

  start: (callback = (->)) ->
    @log.debug "Subscribing to changefeeds"

    createSubscription = (doctype, next) =>
      @database.subscribe doctype, (err, subscription) =>
        return next(err) if err?
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
    @log.debug("#{activity}: #{event.type} #{event.document.id}")
    delegate = (rule, next) =>
      if rule.supports(activity, event)
        rule.handle(activity, event, next)
    async.eachSeries @rules, delegate, (err) =>
      @log.error("Error handling event: #{err.stack ? err}") if err?

module.exports = ChangeWatcher
