_             = require 'lodash'
expect        = require('chai').expect
TestHarness   = require 'test/framework/TestHarness'
GetOrgHandler = require 'apps/api/handlers/orgs/GetOrgHandler'

describe 'orgs:GetOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetOrgHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns the org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        {org} = res.result
        expect(org).to.exist()
        expect(org.id).to.equal(orgid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
