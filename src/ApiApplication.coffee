Application    = require 'common/Application'
ApiEnvironment = require './ApiEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ApiEnvironment()) ->
    super(environment)

  start: ->
    super()
    server = @forge.get('server')
    server.start()

module.exports = ApiApplication
