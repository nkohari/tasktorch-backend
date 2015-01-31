expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetMeHandler    = require 'http/handlers/me/GetMeHandler'

describe 'GetMeHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetMeHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called with credentials', ->
    it 'returns the requester', (done) ->
      @tester.request {credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {user} = res.body
        expect(user).to.exist()
        expect(user.id).to.equal('user-charlie')
        done()

#---------------------------------------------------------------------------------------------------
