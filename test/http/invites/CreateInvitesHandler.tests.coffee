_                    = require 'lodash'
expect               = require('chai').expect
TestHarness          = require 'test/framework/TestHarness'
CreateInvitesHandler = require 'apps/api/handlers/invites/CreateInvitesHandler'

describe 'invites:CreateInvitesHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateInvitesHandler, 'user-frank')
      ready()

  afterEach (done) ->
    TestHarness.reset ['invites'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid   = 'org-oldiesrockcafe'
    payload = {invites: [{email: 'test@test.com', level: 'Leader'}]}

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, payload}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    payload = {invites: [{email: 'test@test.com', level: 'Leader'}]}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without an invites argument', ->

    orgid   = 'org-paddys'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an empty invites argument', ->

    orgid   = 'org-paddys'
    payload = {invites: []}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invite with a missing email property', ->

    orgid   = 'org-paddys'
    payload = {invite: [{level: 'Member'}]}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invite with a missing level property', ->

    orgid   = 'org-paddys'
    payload = {invite: [{email: 'test@test.com'}]}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invite with an invalid level property', ->

    orgid   = 'org-paddys'
    payload = {invite: [{email: 'test@test.com', level: 'doesnotexist'}]}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with one invite for an org of which the requester is a leader', ->

    orgid   = 'org-paddys'
    payload = {invites: [{email: 'z@downbythebridge.com', level: 'Member'}]}

    it 'returns an array containing the created invite', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {invites} = res.result
        expect(invites).to.exist
        expect(invites).to.have.length(1)
        expect(invites[0].email).to.equal(payload.invites[0].email)
        expect(invites[0].level).to.equal(payload.invites[0].level)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with multiple invites for an org of which the requester is a leader', ->

    orgid   = 'org-paddys'
    payload =
      invites: [
        {email: 'z@downbythebridge.com',    level: 'Member'}
        {email: 'larry@underthebridge.com', level: 'Leader'}
      ]

    it 'returns an array containing the created invite', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {invites} = res.result
        expect(invites).to.exist
        expect(invites).to.have.length(2)
        invite1 = _.find invites, (i) -> i.email == payload.invites[0].email
        expect(invite1).to.exist
        expect(invite1.level).to.equal('Member')
        invite2 = _.find invites, (i) -> i.email == payload.invites[1].email
        expect(invite2).to.exist
        expect(invite2.level).to.equal('Leader')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member but not a leader', ->

    orgid       = 'org-paddys'
    payload     = {invites: [{email: 'waitress@coffeeshop.com', level: 'Member'}]}
    credentials = TestHarness.getCredentials('user-charlie')

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    payload = {invites: [{email: 'z@downbythebridge.com', level: 'Member'}]}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()
        
#---------------------------------------------------------------------------------------------------
