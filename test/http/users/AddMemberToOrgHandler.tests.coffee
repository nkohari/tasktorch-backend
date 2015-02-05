_                     = require 'lodash'
expect                = require('chai').expect
TestData              = require 'test/framework/TestData'
TestHarness           = require 'test/framework/TestHarness'
CommonBehaviors       = require 'test/framework/CommonBehaviors'
AddMemberToOrgHandler = require 'http/handlers/users/AddMemberToOrgHandler'

describe 'AddMemberToOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(AddMemberToOrgHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['orgs'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    payload = {user: 'user-greg'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument', ->
    orgid   = 'org-paddys'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the org', ->
    orgid   = 'org-paddys'
    payload = {user: 'user-greg'}
    it 'adds the user as a member of the org and returns the org', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org.members).to.contain('user-greg')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is already a member of the org', ->
    orgid   = 'org-paddys'
    payload = {user: 'user-dee'}
    it 'returns the org without modification', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org.id).to.equal(orgid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    payload = {user: 'user-charlie'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
