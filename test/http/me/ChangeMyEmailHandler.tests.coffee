expect               = require('chai').expect
TestData             = require 'test/framework/TestData'
TestHarness          = require 'test/framework/TestHarness'
CommonBehaviors      = require 'test/framework/CommonBehaviors'
ChangeMyEmailHandler = require 'http/handlers/me/ChangeMyEmailHandler'
GetUserQuery         = require 'data/queries/users/GetUserQuery'

describe 'ChangeMyEmailHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester   = TestHarness.createTester(ChangeMyEmailHandler)
      @database = TestHarness.getDatabase()
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
        query = new GetUserQuery(user.id)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {user} = result
          expect(user).to.exist()
          expect(user.email).to.equal(payload.email)
          reset(done)

#---------------------------------------------------------------------------------------------------
