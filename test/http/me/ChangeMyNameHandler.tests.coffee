expect              = require('chai').expect
TestData            = require 'test/framework/TestData'
TestHarness         = require 'test/framework/TestHarness'
CommonBehaviors     = require 'test/framework/CommonBehaviors'
ChangeMyNameHandler = require 'apps/api/handlers/me/ChangeMyNameHandler'

describe 'ChangeMyNameHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyNameHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['users'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a name argument', ->

    it 'returns the updated user', (done) ->
      payload = {name: 'Dayman'}
      @tester.request {credentials, payload}, (res) ->
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user.id).to.equal('user-charlie')
        expect(user.version).to.equal(1)
        expect(user.name).to.equal('Dayman')
        reset(done)

#---------------------------------------------------------------------------------------------------
