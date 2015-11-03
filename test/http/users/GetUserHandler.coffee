_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetUserHandler  = require 'apps/api/handlers/users/GetUserHandler'

describe 'GetUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetUserHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {userid: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent user', ->
    it 'returns 404 not found', (done) ->
      @tester.request {userid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid user', ->
    it 'returns the user', (done) ->
      @tester.request {userid: 'user-frank', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.id).to.equal('user-frank')
        done()

#---------------------------------------------------------------------------------------------------
