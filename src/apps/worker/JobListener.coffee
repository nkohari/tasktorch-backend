_     = require 'lodash'
async = require 'async'

class JobListener

  constructor: (@log, @jobQueue, @jobProcessor) ->

  start: ->
    @log.debug "Polling job queue"
    poll = () =>
      @receive =>
        setImmediate(poll) unless @stopRequested
    poll()

  stop: ->
    @stopRequested = true

  receive: (callback) ->
    @jobQueue.dequeue (err, jobs) =>
      if err? or not jobs?
        return callback()
      else
        async.eachSeries jobs, ((job, next) => @handle(job, next)), callback

  handle: (job, callback) ->
    @jobProcessor.process job, (err) =>
      if err?
        @log.error "Error while processing job #{job.id}: #{err.stack ? err}"
        return callback()
      @log.debug "Job #{job.id} processed successfully, acknowledging"
      @jobQueue.ack(job, callback)

module.exports = JobListener
