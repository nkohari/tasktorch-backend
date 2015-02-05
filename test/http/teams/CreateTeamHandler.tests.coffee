_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
CreateTeamHandler = require 'http/handlers/teams/CreateTeamHandler'

describe 'CreateTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateTeamHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['teams'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    payload = {name: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->
    orgid   = 'org-paddys'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->
    orgid   = 'org-paddys'
    payload = {name: null}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a leaders argument containing a non-existent user', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', leaders: ['doesnotexist']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a leaders argument containing some valid and some non-existent users', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', leaders: ['user-frank', 'doesnotexist']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a leaders argument containing a user that is not a member of the org', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', leaders: ['user-frank', 'user-greg']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a members argument containing a non-existent user', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', members: ['doesnotexist']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a members argument containing some valid and some non-existent users', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', members: ['user-frank', 'doesnotexist']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a members argument containing a user that is not a member of the org', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', members: ['user-frank', 'user-greg']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a leaders argument that is not a proper subset of the members argument', ->
    orgid   = 'org-paddys'
    payload = {name: 'Test', leaders: ['user-frank', 'user-charlie'], members: ['user-frank']}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a name argument and no leaders or members arguments', ->
    orgid   = 'org-paddys'
    payload = {name: new Date().valueOf().toString()}
    it 'creates and returns the team, adding the requester as the sole leader and member', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.name).to.equal(payload.name)
        expect(team.members).to.have.length(1)
        expect(team.members).to.have.members ['user-charlie']
        expect(team.leaders).to.have.length(1)
        expect(team.leaders).to.have.members ['user-charlie']
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid name and leaders argument', ->
    orgid   = 'org-paddys'
    payload = {name: new Date().valueOf().toString(), leaders: ['user-charlie'], members: ['user-charlie', 'user-mac']}
    it 'creates and returns the team', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.name).to.equal(payload.name)
        expect(team.leaders).to.have.length(1)
        expect(team.leaders).to.have.members ['user-charlie']
        expect(team.members).to.have.length(2)
        expect(team.members).to.have.members ['user-charlie', 'user-mac']
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    payload = {name: 'Test'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
