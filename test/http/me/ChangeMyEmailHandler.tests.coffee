expect               = require('chai').expect
TestData             = require 'test/framework/TestData'
TestHarness          = require 'test/framework/TestHarness'
CommonBehaviors      = require 'test/framework/CommonBehaviors'
ChangeMyEmailHandler = require 'http/handlers/me/ChangeMyEmailHandler'

describe 'ChangeMyEmailHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyEmailHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['users'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called without an email argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an email argument', ->

    it 'changes the email address for the user', (done) ->
      payload = {email: 'kitten.mittons@charliekelly.com'}
      @tester.request {credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.email).to.equal(payload.email)
        reset(done)

#---------------------------------------------------------------------------------------------------
