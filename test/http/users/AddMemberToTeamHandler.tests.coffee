_                      = require 'lodash'
expect                 = require('chai').expect
TestData               = require 'test/framework/TestData'
TestHarness            = require 'test/framework/TestHarness'
CommonBehaviors        = require 'test/framework/CommonBehaviors'
AddMemberToTeamHandler = require 'http/handlers/users/AddMemberToTeamHandler'

describe 'AddMemberToTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(AddMemberToTeamHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['teams'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', teamid: 'team-gruesometwosome'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    teamid  = 'team-gruesometwosome'
    payload = {user: 'user-mac'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument', ->
    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the org', ->
    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {user: 'user-greg'}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the team', ->
    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {user: 'user-mac'}
    it 'adds the user as a member of the team', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.id).to.equal(teamid)
        expect(team.members).to.contain('user-mac')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is already a member of the team', ->
    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {user: 'user-frank'}
    it 'returns the team without modification', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.id).to.equal(teamid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    teamid  = 'team-sudz'
    payload = {user: 'user-charlie'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, teamid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
