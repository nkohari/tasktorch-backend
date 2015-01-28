Application           = require 'common/Application'
ProductionEnvironment = require './ProductionEnvironment'

class ApiApplication extends Application

  name: 'api'

  constructor: (environment = new ProductionEnvironment()) ->
    super(environment)

  start: ->
    super()
    server = @forge.get('server')
    server.start()

module.exports = ApiApplication
