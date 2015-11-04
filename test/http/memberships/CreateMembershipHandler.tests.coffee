_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
CreateMembershipHandler = require 'apps/api/handlers/memberships/CreateMembershipHandler'

describe 'memberships:CreateMembershipHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateMembershipHandler, 'user-frank')
      ready()

  afterEach (done) ->
    TestHarness.reset ['memberships'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    payload = {user: 'user-greg'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument', ->

    orgid   = 'org-paddys'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the org', ->

    orgid   = 'org-paddys'
    payload = {user: 'user-greg'}

    it 'creates and returns a new membership for the user', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {membership} = res.result
        expect(membership.user).to.equal(payload.user)
        expect(membership.org).to.equal(orgid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is already a member of the org', ->

    orgid   = 'org-paddys'
    payload = {user: 'user-dee'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a leader', ->

    orgid       = 'org-paddys'
    payload     = {user: 'user-greg'}
    credentials = TestHarness.getCredentials('user-charlie')

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    payload = {user: 'user-charlie'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
