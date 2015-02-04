ApiApplication  = require '../../src/ApiApplication'
TestEnvironment = require './TestEnvironment'
HandlerTester   = require './HandlerTester'

class TestHarness

  constructor: ->
    @app = new ApiApplication(new TestEnvironment())
    @started = false

  start: (callback) ->
    return callback() if @started
    @started = true
    @app.start (err) =>
      return callback(err) if err?
      @server = @app.forge.get('server').server
      callback()

  createTester: (handler) ->
    new HandlerTester(@server, handler)

  getDatabase: ->
    @app.forge.get('database')

module.exports = new TestHarness()
