async             = require 'async'
Application       = require 'common/Application'
WorkerEnvironment = require './WorkerEnvironment'

class WorkerApplication extends Application

  name: 'worker'

  constructor: (environment = new WorkerEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()
    jobListener = @forge.get('jobListener')
    jobListener.start()

module.exports = WorkerApplication
