_     = require 'lodash'
async = require 'async'

class JobListener

  constructor: (@log, @aws, @config, @processor) ->
    @sqs = @aws.createSQSClient()

  start: ->
    @log.debug "Polling #{@config.jobs.queueUrl} every #{@config.jobs.waitTimeSeconds} seconds"
    poll = () =>
      @receive =>
        setImmediate(poll) unless @stopRequested
    poll()

  stop: ->
    @stopRequested = true

  receive: (callback) ->

    @sqs.receiveMessage {
      QueueUrl:            @config.jobs.queueUrl
      WaitTimeSeconds:     @config.jobs.waitTimeSeconds
      MaxNumberOfMessages: @config.jobs.maxNumberOfMessages
    }, (err, result) =>

      if err?
        # TODO: Use node-retry to stop polling after a certain number of failures?
        @log.error "Error receiving messages from SQS: #{err}"
        return callback()

      unless result.Messages?.length > 0
        @log.debug "No messages available from SQS"
        return callback()

      jobs = _.map result.Messages, (message) =>
        _.extend(JSON.parse(message.Body), {
          id:     message.MessageId
          handle: message.ReceiptHandle
        })

      @log.debug "Received #{jobs.length} jobs from SQS"

      async.each jobs, ((job, next) => @handle(job, next)), callback

  handle: (job, callback) ->

    @processor.process job, (err) =>

      if err?
        @log.error "Error while processing job #{job.id}: #{err.stack ? err}"
        return callback()

      @log.debug "Job #{job.id} processed successfully, removing from SQS"

      @sqs.deleteMessage {
        QueueUrl:      @config.jobs.queueUrl
        ReceiptHandle: job.handle
      }, (err) =>
        if err?
          @log.error "Error deleting job #{job.id} from SQS: #{err}"
        else
          @log.debug "Job #{job.id} successfully deleted from SQS"
        callback()

module.exports = JobListener
