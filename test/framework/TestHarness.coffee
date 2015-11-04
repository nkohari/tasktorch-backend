r               = require 'rethinkdb'
ApiApplication  = require '../../src/apps/api/ApiApplication'
DatabaseCreator = require './DatabaseCreator'
TestData        = require './TestData'
TestEnvironment = require './TestEnvironment'
HandlerTester   = require './HandlerTester'

class TestHarness

  constructor: ->
    @app = new ApiApplication(new TestEnvironment())
    @started = false

  start: (callback) ->

    return callback() if @started
    @started = true

    {host, port, db} = @app.forge.get('config').rethinkdb

    r.connect {host, port, db}, (err, conn) =>
      return callback(err) if err?
      @connection = conn
      @app.start (err) =>
        return callback(err) if err?
        @server = @app.forge.get('server').server
        callback()

  reset: (tables, callback) ->
    TestData.reset(@connection, tables, callback)

  createTester: (handler, userid = undefined) ->
    if userid?
      credentials = @getCredentials(userid)
    else
      credentials = undefined
    new HandlerTester(@server, handler, credentials)

  getDatabase: ->
    @app.forge.get('database')

  getCredentials: (userid) ->
    {user: TestData.users[userid]}

module.exports = new TestHarness()
