expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
ChangeMyNameHandler = require 'apps/api/handlers/me/ChangeMyNameHandler'

describe 'me:ChangeMyNameHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyNameHandler, 'user-charlie')
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

  describe 'when called without a name argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a name argument', ->

    payload = {name: 'Dayman'}

    it 'returns the updated user', (done) ->
      @tester.request {payload}, (res) ->
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user.id).to.equal('user-charlie')
        expect(user.version).to.equal(1)
        expect(user.name).to.equal(payload.name)
        done()

#---------------------------------------------------------------------------------------------------
