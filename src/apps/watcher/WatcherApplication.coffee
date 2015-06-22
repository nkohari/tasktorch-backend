async              = require 'async'
Application        = require 'common/Application'
WatcherEnvironment = require './WatcherEnvironment'

class WatcherApplication extends Application

  name: 'watcher'

  constructor: (environment = new WatcherEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()
    watcher = @forge.get('watcher')
    watcher.start()

module.exports = WatcherApplication
