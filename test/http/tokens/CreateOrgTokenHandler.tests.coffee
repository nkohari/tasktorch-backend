_                     = require 'lodash'
expect                = require('chai').expect
TestData              = require 'test/framework/TestData'
TestHarness           = require 'test/framework/TestHarness'
CommonBehaviors       = require 'test/framework/CommonBehaviors'
CreateOrgTokenHandler = require 'http/handlers/tokens/CreateOrgTokenHandler'

describe 'CreateOrgTokenHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateOrgTokenHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['tokens'], callback

  credentials =
    user: TestData.users['user-charlie']

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid = 'org-sudz'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid = 'org-paddys'
    it 'creates and returns the token', (done) ->
      @tester.request {orgid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {token} = res.result
        expect(token.creator).to.equal(credentials.user.id)
        expect(token.org).to.equal(orgid)
        reset(done)

#---------------------------------------------------------------------------------------------------
