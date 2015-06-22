_ = require 'lodash'

class Job

  @fromSQSMessage: (message) ->
    job = new this()

    job.id     = message.Id
    job.handle = message.ReceiptHandle

    for key, value of JSON.parse(message.Body)
      job[key] = value

    return job

  constructor: ->
    @type = @constructor.name.replace(/Job/, '')

module.exports = Job
