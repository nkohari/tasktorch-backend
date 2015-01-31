expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
ListMyOrgsHandler = require 'http/handlers/me/ListMyOrgsHandler'

describe 'ListMyOrgsHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyOrgsHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called with credentials', ->
    it 'returns an array of orgs of which requester is a member', (done) ->
      @tester.request {credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {orgs} = res.body
        expect(orgs).to.exist()
        expect(orgs).to.have.length(1)
        expect(orgs[0].id).to.equal('org-paddys')
        done()

#---------------------------------------------------------------------------------------------------
