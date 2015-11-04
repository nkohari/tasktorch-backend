expect               = require('chai').expect
TestHarness          = require 'test/framework/TestHarness'
ChangeMyEmailHandler = require 'apps/api/handlers/me/ChangeMyEmailHandler'

describe 'me:ChangeMyEmailHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMyEmailHandler, 'user-charlie')
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

  describe 'when called without an email argument', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an email argument', ->

    payload = {email: 'kitten.mittons@charliekelly.com'}

    it 'changes the email address for the user', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.email).to.equal(payload.email)
        done()

#---------------------------------------------------------------------------------------------------
