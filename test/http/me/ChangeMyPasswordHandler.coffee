expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ChangeMyPasswordHandler = require 'apps/api/handlers/me/ChangeMyPasswordHandler'

describe 'me:ChangeMyPasswordHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyPasswordHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['users'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    it 'returns 401 unauthorized', (done) ->
      @tester.request {credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a password argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a password argument', ->

    payload = {password: 'ghouls'}

    it 'returns 200 ok', (done) ->
      @tester.request {payload}, (res) ->
        expect(res.statusCode).to.equal(200)
        done()

#---------------------------------------------------------------------------------------------------
