_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetUserHandler  = require 'apps/api/handlers/users/GetUserHandler'

describe 'users:GetUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetUserHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    userid = 'user-charlie'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {userid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent user', ->

    userid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid user', ->

    userid = 'user-frank'

    it 'returns the user', (done) ->
      @tester.request {userid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.id).to.equal(userid)
        done()

#---------------------------------------------------------------------------------------------------
