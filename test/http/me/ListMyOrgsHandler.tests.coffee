expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
ListMyOrgsHandler = require 'apps/api/handlers/me/ListMyOrgsHandler'

describe 'me:ListMyOrgsHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyOrgsHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    it 'returns 401 unauthorized', (done) ->
      @tester.request {credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with credentials', ->
    
    it 'returns an array of orgs of which requester is a member', (done) ->
      @tester.request {}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {orgs} = res.result
        expect(orgs).to.exist()
        expect(orgs).to.have.length(1)
        expect(orgs[0].id).to.equal('org-paddys')
        done()

#---------------------------------------------------------------------------------------------------
