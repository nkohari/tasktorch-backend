_                          = require 'lodash'
expect                     = require('chai').expect
TestData                   = require 'test/framework/TestData'
TestHarness                = require 'test/framework/TestHarness'
CommonBehaviors            = require 'test/framework/CommonBehaviors'
RemoveMemberFromOrgHandler = require 'http/handlers/users/RemoveMemberFromOrgHandler'

describe 'RemoveMemberFromOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(RemoveMemberFromOrgHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['orgs'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', userid: 'user-dee'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid  = 'doesnotexist'
    userid = 'user-dee'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a user who is not a member of the org', ->
    orgid  = 'org-paddys'
    userid = 'user-greg'
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a user who is a member of the org but not a leader', ->
    orgid  = 'org-paddys'
    userid = 'user-dee'
    it 'removes the user as a member', (done) ->
      @tester.request {orgid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org.id).to.equal(orgid)
        expect(org.members).to.be.an('array')
        expect(org.members).not.to.contain(userid)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is both a member and a leader of the org', ->
    orgid  = 'org-paddys'
    userid = 'user-mac'
    it 'removes the user as a member and a leader', (done) ->
      @tester.request {orgid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org.id).to.equal(orgid)
        expect(org.leaders).to.be.an('array')
        expect(org.leaders).not.to.contain(userid)
        expect(org.members).to.be.an('array')
        expect(org.members).not.to.contain(userid)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid  = 'org-sudz'
    userid = 'user-greg'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
