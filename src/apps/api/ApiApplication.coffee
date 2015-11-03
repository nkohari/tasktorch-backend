async          = require 'async'
Application    = require 'common/Application'
ApiEnvironment = require './ApiEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ApiEnvironment()) ->
    super(environment)

  start: (callback = (->)) ->
    super()
    server = @forge.get('server')
    server.start(callback)

module.exports = ApiApplication
