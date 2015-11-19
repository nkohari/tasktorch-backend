_                   = require 'lodash'
expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
ListMyStacksHandler = require 'apps/api/handlers/me/ListMyStacksHandler'

describe 'me:ListMyStacksHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyStacksHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid = 'org-oldiesrockcafe'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of stacks owned by the requester in that org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {stacks} = res.result
        expect(stacks).to.be.an('array')
        expect(stacks).to.have.length(4)
        expect(_.pluck(stacks, 'id')).to.have.members ['stack-charlie-inbox', 'stack-charlie-queue', 'stack-charlie-drafts', 'stack-charlie-dreams']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
