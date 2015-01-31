Application           = require 'common/Application'
ProductionEnvironment = require './ProductionEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ProductionEnvironment()) ->
    super(environment)

  start: ->
    super()
    databaseWatcher = @forge.get('databaseWatcher')
    databaseWatcher.start (err) =>
      console.log 'here'
      if err?
        @log.error "Error starting database watcher: #{err}"
        process.exit(1)
      server = @forge.get('server')
      server.start()

module.exports = ApiApplication
