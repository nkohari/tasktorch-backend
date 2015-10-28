path      = require 'path'
_         = require 'lodash'
loadFiles = require 'common/util/loadFiles'

CLASSES = undefined
getClassHash = ->
  unless CLASSES?
    files   = loadFiles('jobs', path.resolve(__dirname, '..'))
    CLASSES = _.indexBy files, (t) -> t.name.replace(/Job$/, '')
  return CLASSES

class Job

  @fromSQSMessage: (message) ->

    data  = JSON.parse(message.Body)
    klass = getClassHash()[data.type]

    unless klass?
      throw new Error("Don't know how to create a job of type #{data.type}")

    job = new klass()

    job.id     = message.MessageId
    job.handle = message.ReceiptHandle

    for key, value of data
      job[key] = value

    return job

  constructor: ->
    @type = @constructor.name.replace(/Job$/, '')

module.exports = Job
