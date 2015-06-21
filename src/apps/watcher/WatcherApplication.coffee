async              = require 'async'
Application        = require 'common/Application'
WatcherEnvironment = require './WatcherEnvironment'

class WatcherApplication extends Application

  name: 'watcher'

  constructor: (environment = new WatcherEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()

    @log = @forge.get('log')
    
    messageBus = @forge.get('messageBus')
    messageBus.start (err) =>
      if err?
        @log.error "Error starting message bus: #{err}"
        process.exit(1)
      watcher = @forge.get('watcher')
      watcher.start (err) =>
        if err?
          @log.error "Error starting watcher: #{err}"
          process.exit(1)

module.exports = WatcherApplication
