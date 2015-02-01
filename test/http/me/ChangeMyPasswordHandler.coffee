expect                  = require('chai').expect
TestData                = require 'test/framework/TestData'
TestHarness             = require 'test/framework/TestHarness'
CommonBehaviors         = require 'test/framework/CommonBehaviors'
ChangeMyPasswordHandler = require 'http/handlers/me/ChangeMyPasswordHandler'

describe 'ChangeMyPasswordHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyPasswordHandler)
      ready()

  afterEach (done) ->
    TestData.reset ['users'], done

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a password argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a password argument', ->

    it 'returns 200 ok', (done) ->
      payload = {password: 'ghouls'}
      @tester.request {credentials, payload}, (res) ->
        expect(res.statusCode).to.equal(200)
        done()

#---------------------------------------------------------------------------------------------------
