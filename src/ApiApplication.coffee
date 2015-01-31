async                 = require 'async'
Application           = require 'common/Application'
ProductionEnvironment = require './ProductionEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ProductionEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()

    startService = (name, next) =>
      service = @forge.get(name)
      service.start (err) =>
        if err?
          @log.error "Error starting service #{name}: #{err}"
          process.exit(1)
        next()

    services = ['databaseWatcher', 'messageBus', 'server']
    async.eachSeries(services, startService, callback)

module.exports = ApiApplication
