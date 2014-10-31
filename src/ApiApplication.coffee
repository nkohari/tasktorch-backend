Application    = require 'common/Application'
ApiEnvironment = require './ApiEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ApiEnvironment()) ->
    super(environment)
    process.on('uncaughtException', @onError.bind(this))

  start: ->
    super()
    server = @forge.get('server')
    server.start()

  onError: (error) ->
    @forge.get('log').error("UNCAUGHT EXCEPTION: #{error.stack ? error}")
    process.exit(1)

module.exports = ApiApplication
