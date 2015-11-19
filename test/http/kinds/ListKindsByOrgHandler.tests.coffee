_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ListKindsByOrgHandler = require 'apps/api/handlers/kinds/ListKindsByOrgHandler'

describe 'kinds:ListKindsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListKindsByOrgHandler, 'user-charlie')
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

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of kinds defined for the org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {kinds} = res.result
        expect(kinds).to.exist
        expect(kinds).to.have.length(1)
        expect(_.pluck(kinds, 'id')).to.have.members ['kind-scheme']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
