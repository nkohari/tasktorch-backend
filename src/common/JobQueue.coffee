_     = require 'lodash'
async = require 'async'
Job   = require 'domain/framework/Job'

MAX_JOBS_PER_BATCH = 10

class JobQueue

  constructor: (@log, @config, @aws) ->
    @sqs = @aws.createSQSClient()

  enqueue: (job, callback) ->
    @log.debug "[jobqueue] Enqueueing #{job.type}"
    @sqs.sendMessage {
      QueueUrl:    @config.jobs.queueUrl
      MessageBody: JSON.stringify(job)
    }, (err) =>
      if err?
        @log.error("[jobqueue] Error enqueuing job: #{err.stack ? err}")
        return callback(err)
      @log.debug "[jobqueue] Job successfully enqueued"
      callback()

  enqueueBatch: (jobs, callback) ->
    jobs   = _.flatten [jobs]
    chunks = _.chunk(jobs, MAX_JOBS_PER_BATCH)
    @log.debug "[jobqueue] Enqueueing #{jobs.length} jobs in #{chunks.length} batches"
    sendChunk = (chunk, next) =>
      entries = _.map chunk, (job, index) => {
        Id: index.toString()
        MessageBody: JSON.stringify(job)
      }
      @sqs.sendMessageBatch {
        Entries:  entries
        QueueUrl: @config.jobs.queueUrl
      }, next
    async.eachSeries chunks, sendChunk, (err) =>
      if err?
        @log.error("[jobqueue] Error enqueuing batch: #{err.stack ? err}")
        return callback(err)
      @log.debug "[jobqueue] All jobs successfully enqueued"
      callback()

  dequeue: (callback) ->
    @log.debug "[jobqueue] Waiting for jobs"
    @sqs.receiveMessage {
      QueueUrl:            @config.jobs.queueUrl
      WaitTimeSeconds:     @config.jobs.waitTimeSeconds
      MaxNumberOfMessages: @config.jobs.maxNumberOfMessages
    }, (err, result) =>
      if err?
        @log.error "[jobqueue] Error receiving messages from SQS: #{err}"
        return callback(err)
      unless result.Messages?.length > 0
        return callback(err)
      jobs = _.map(result.Messages, Job.fromSQSMessage)
      @log.debug "[jobqueue] Received #{jobs.length} jobs"
      callback(null, jobs)

  ack: (job, callback) ->
    @log.debug "[jobqueue] Deleting job #{job.id}"
    @sqs.deleteMessage {
      QueueUrl:      @config.jobs.queueUrl
      ReceiptHandle: job.handle
    }, (err) =>
      if err?
        @log.error "[jobqueue] Error deleting job #{job.id} from SQS: #{err}"
        return callback(err)
      @log.debug "[jobqueue] Job #{job.id} successfully deleted"
      callback()


module.exports = JobQueue
