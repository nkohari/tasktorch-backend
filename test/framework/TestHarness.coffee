ApiApplication  = require '../../src/ApiApplication'
TestEnvironment = require './TestEnvironment'
HandlerTester   = require './HandlerTester'

class TestHarness

  constructor: ->
    @app = new ApiApplication(new TestEnvironment())
    @app.start()
    @server = @app.forge.get('server').server

  createTester: (handler) ->
    new HandlerTester(@server, handler)

module.exports = new TestHarness()
