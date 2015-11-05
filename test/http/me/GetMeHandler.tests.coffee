expect       = require('chai').expect
TestHarness  = require 'test/framework/TestHarness'
GetMeHandler = require 'apps/api/handlers/me/GetMeHandler'

describe 'me:GetMeHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetMeHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    it 'returns 401 unauthorized', (done) ->
      @tester.request {credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with credentials', ->

    it 'returns the requester', (done) ->
      @tester.request {}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {user} = res.result
        expect(user).to.exist
        expect(user.id).to.equal('user-charlie')
        done()

#---------------------------------------------------------------------------------------------------
