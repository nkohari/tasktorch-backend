_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetOrgHandler   = require 'http/handlers/orgs/GetOrgHandler'

describe 'GetOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before ->
    @tester = TestHarness.createTester(GetOrgHandler)

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an org of which the requester is a member', ->
    it 'returns the org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        {org} = res.body
        expect(org).to.exist()
        expect(org.id).to.equal('org-paddys')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with expand=members', ->
    it 'returns the org and the users in the members list', (done) ->
      @tester.request {orgid: 'org-paddys', query: {expand: 'members'}, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        expect(res.body.related).to.exist()
        {org}   = res.body
        {users} = res.body.related
        missing = _.difference(org.members, _.keys(users))
        expect(missing).to.be.empty()
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with expand=leaders', ->
    it 'returns the org and the users in the leaders list', (done) ->
      @tester.request {orgid: 'org-paddys', query: {expand: 'leaders'}, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        expect(res.body.related).to.exist()
        {org}   = res.body
        {users} = res.body.related
        missing = _.difference(org.leaders, _.keys(users))
        expect(missing).to.be.empty()
        done()

#---------------------------------------------------------------------------------------------------
